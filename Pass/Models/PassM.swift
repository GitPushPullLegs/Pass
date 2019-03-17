//
//  PassM.swift
//  Pass
//
//  Created by Jose Aguilar on 3/16/19.
//  Copyright © 2019 Jose Aguilar. All rights reserved.
//

import UIKit
import RealmSwift

class PassM: Object {
    @objc dynamic var title = ""
    @objc dynamic var code = ""
    @objc dynamic var isCode39 = false
    @objc dynamic var isOnWatch = false
    @objc dynamic var isOnWidget = false

    // Ignored Properties
    var image: UIImage {
        return UIImage()
    }
}
