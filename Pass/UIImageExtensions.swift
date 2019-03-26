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
