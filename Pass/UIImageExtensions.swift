//
//  UIImageExtensions.swift
//  Pass
//
//  Created by Jose Aguilar on 3/25/19.
//  Copyright © 2019 Jose Aguilar. All rights reserved.
//

import UIKit

extension UIImage {
    static func imageFromColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)

        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        color.setFill()
        UIRectFill(rect)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

extension UIImage {

    //MARK: - QR

    static func qr(fromString string: String) -> UIImage {
        let data = string.data(using: String.Encoding.utf8)!

        // swiftlint:disable:next identifier_name
        let qr = CIFilter(name: "CIQRCodeGenerator", parameters: ["inputMessage": data, "inputCorrectionLevel": "M"])!
        let qrColorChanged = CIFilter(name: "CIFalseColor", parameters: ["inputImage": qr.outputImage!, "inputColor0": CIColor.black, "inputColor1": CIColor.clear])!
        let sizeTransform = CGAffineTransform(scaleX: 20, y: 20)
        let qrImage = qrColorChanged.outputImage!.transformed(by: sizeTransform)

        var qrUIImage = UIImage(ciImage: qrImage)
        UIGraphicsBeginImageContextWithOptions(qrUIImage.size, false, qrUIImage.scale)
        qrUIImage.draw(at: CGPoint.zero)
        qrUIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return qrUIImage
    }

    //MARK: - Code39

    private static var alpha: String {
        return "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ-. $/+%*"
    }

    private static var characterEncodings: [String] {
        return [
            "1010011011010", "1101001010110", "1011001010110", "1101100101010", "1010011010110", "1101001101010",
            "1011001101010", "1010010110110", "1101001011010", "1011001011010", "1101010010110", "1011010010110",
            "1101101001010", "1010110010110", "1101011001010", "1011011001010", "1010100110110", "1101010011010",
            "1011010011010", "1010110011010", "1101010100110", "1011010100110", "1101101010010", "1010110100110",
            "1101011010010", "1011011010010", "1010101100110", "1101010110010", "1011010110010", "1010110110010",
            "1100101010110", "1001101010110", "1100110101010", "1001011010110", "1100101101010", "1001101101010",
            "1001010110110", "1100101011010", "1001101011010", "1001001001010", "1001001010010", "1001010010010",
            "1010010010010", "1001011011010"
        ]
    }

    static func canGenerateCode39(fromString string: String) -> Bool {
        if string.count > 0
            && string.range(of: "*") == nil
            && string == string.uppercased() {
            for character in string {
                let location = alpha.location(String(character))
                if location == NSNotFound {
                    return false
                }
            }
            return true
        }
        return false
    }

    static func code39(fromString string: String) -> UIImage? {
        let completeBarcode = encode(string)
        let length: Int = completeBarcode.length()
        if length <= 0 {
            return nil
        }

        // Values taken from CIImage generated AVMetadataObjectTypePDF417Code type image
        // Top spacing          = 1.5
        // Bottom spacing       = 2
        // Left & right spacing = 2
        // Height               = 28
        let width = (length + 4)
        let size = CGSize(width: CGFloat(width), height: 140)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        if let context = UIGraphicsGetCurrentContext() {
            context.setShouldAntialias(false)

            UIColor.white.setFill()
            UIColor.black.setStroke()

            context.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
            context.setLineWidth(1)

            for index in 0..<length {
                // swiftlint:disable:next for_where
                if completeBarcode[index] == "1" {
                    // swiftlint:disable:next identifier_name
                    let x = index + (2 + 1)
                    context.move(to: CGPoint(x: CGFloat(x), y: 1.5))
                    context.addLine(to: CGPoint(x: CGFloat(x), y: size.height - 2))
                }
            }
            context.drawPath(using: CGPathDrawingMode.fillStroke)
            return UIGraphicsGetImageFromCurrentImageContext()
        } else {
            return nil
        }
    }

    private static func encodeCharacterString(_ characterString: String) -> String {
        let location = UIImage.alpha.location(characterString)
        return UIImage.characterEncodings[location]
    }

    private static func encode(_ contents: String) -> String {
        var barcode = ""
        for character in contents {
            barcode += self.encodeCharacterString(String(character))
        }
        let initiatorTerminator = self.encodeCharacterString("*")
        return "\(initiatorTerminator)\(barcode)\(initiatorTerminator)"
    }
}

fileprivate extension String {
    // Used in encodeCharacterString
    func location(_ other: String) -> Int {
        return (self as NSString).range(of: other).location
    }

    // Used in isValid
    func length() -> Int {
        return self.count
    }

    func substring(_ location: Int, length: Int) -> String! {
        // swiftlint:disable:next legacy_constructor
        return (self as NSString).substring(with: NSMakeRange(location, length))
    }

    subscript(index: Int) -> String! {
        return self.substring(index, length: 1)
    }
}
