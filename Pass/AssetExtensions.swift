//
//  AssetExtensions.swift
//  Pass
//
//  Created by Jose Aguilar on 3/16/19.
//  Copyright © 2019 Jose Aguilar. All rights reserved.
//

import UIKit

extension UIColor {
    enum Asset: String {
        case primary = "Primary"
    }

    convenience init?(asset: Asset) {
        self.init(named: asset.rawValue)
    }
}

extension UIImage {
    enum Asset: String {
        case none = "" // Will return nil, temporary placeholder to silence error.
    }

    convenience init?(asset: Asset) {
        self.init(named: asset.rawValue)
    }
}
