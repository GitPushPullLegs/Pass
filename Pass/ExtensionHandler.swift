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

    static func setWidget(toPass pass: PassM) {
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
