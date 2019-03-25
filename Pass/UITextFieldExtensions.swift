//
//  UITextFieldExtensions.swift
//  Pass
//
//  Created by Jose Aguilar on 3/25/19.
//  Copyright © 2019 Jose Aguilar. All rights reserved.
//

import UIKit

extension UITextField {
    var cleanedString: String {
        guard let text = self.text else { return "" }
        return text.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
