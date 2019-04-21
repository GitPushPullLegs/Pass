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
            print(error) //TODO: - Another reminder to do proper error handling
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
}
