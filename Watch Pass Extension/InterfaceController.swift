//
//  InterfaceController.swift
//  Watch Pass Extension
//
//  Created by Jose Aguilar on 4/21/19.
//  Copyright © 2019 Jose Aguilar. All rights reserved.
//

import WatchKit
import Foundation

class InterfaceController: WKInterfaceController {

    @IBOutlet weak var imageView: WKInterfaceImage!

    @IBAction func repeatAction() {
        setData()
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        setData()
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    private func setData() {
        if let passData = PassHandler.retrievePassData() {
            imageView.setImage(UIImage(data: passData))
        }
        if let passTitle = PassHandler.retrieveFromDefaults(withKey: .title) {
            self.setTitle(passTitle as? String)
        }
    }

}
