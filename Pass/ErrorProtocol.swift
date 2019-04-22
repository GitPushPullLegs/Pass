//
//  ErrorProtocol.swift
//  Pass
//
//  Created by Jose Aguilar on 4/21/19.
//  Copyright © 2019 Jose Aguilar. All rights reserved.
//

import UIKit

protocol ErrorProtocol {
    func presentError(withTitle title: String, withText text: String)
}

extension ErrorProtocol where Self: UIViewController {
    func presentError(withTitle title: String, withText text: String) {
        let errorAlertController = UIAlertController(title: title, message: text, preferredStyle: .alert)
        errorAlertController.view.tintColor = UIColor(asset: .primary)

        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        errorAlertController.addAction(okAction)

        self.navigationController?.present(errorAlertController, animated: true, completion: nil)
    }
}
