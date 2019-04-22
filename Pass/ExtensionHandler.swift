//
//  ExtensionHandler.swift
//  Pass
//
//  Created by Jose Aguilar on 4/20/19.
//  Copyright © 2019 Jose Aguilar. All rights reserved.
//

import UIKit
import RealmSwift

class ExtensionHandler {

    //MARK: - Widget

    /// Shares this pass's information with the Today Widget via a shared UserDefaults. Also, set's the isOnWidget variable to true.
    static func setWidget(toPass pass: PassM) {
        setDefaults(forPass: pass)

        do {
//            try pass.setValue(true, forKey: .isOnWidget)
            try pass.setUniqueValue(true, forKey: .isOnWidget)
        } catch {
            print(error)
        }
    }

    private static func setDefaults(forPass pass: PassM) {
        guard let defaults = UserDefaults(suiteName: "group.joeyisthebest.Pass.Today") else {
            fatalError("ExtensionHandler: Cannot access UserDefaults.")
        }

        let imageData = pass.image.pngData()

        defaults.setValue(pass.title, forKeyPath: "title")
        defaults.setValue(pass.code, forKeyPath: "code")
        defaults.setValue(imageData, forKeyPath: "imageData")
        defaults.setValue(pass.isCode39, forKeyPath: "isCode39")
    }

    //MARK: - Watch App

    static func setWatch(toPass pass: PassM) {
        let session = WatchHandler.shared
        let fileURL = storeToFileManager(image: pass.qrImage)
        let passData: [String: Any] = ["title": pass.title,
                                       "code": pass.code]

        session.sendPassDataToWatch(file: fileURL, metadata: passData)

        do {
            try pass.setUniqueValue(true, forKey: .isOnWatch)
        } catch {
            print(error)
        }
    }

    private static func storeToFileManager(image: UIImage) -> URL {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { fatalError() }

        let fileName = "currentPass"
        let fileURL = documentsDirectory.appendingPathComponent(fileName)

        guard let imageData = image.pngData() ?? image.jpegData(compressionQuality: 1) else { fatalError() }

        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
            } catch {
                print(error)
            }
        }

        do {
            try imageData.write(to: fileURL)
        } catch {
            print(error)
        }

        return fileURL
    }
}
