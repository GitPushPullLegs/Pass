//
//  ChirpController.swift
//  Pass
//
//  Created by Jose Aguilar on 4/24/19.
//  Copyright © 2019 Jose Aguilar. All rights reserved.
//

import UIKit
import ChirpConnect

class ChirpController: NSObject {

    static let shared = ChirpController()

    let chirp = ChirpConnect(appKey: SecretsHandler.chirpAppKey, andSecret: SecretsHandler.chirpAppSecret)

    private override init() {
        super.init()

        if let error = chirp?.setConfig(SecretsHandler.chirpAppConfig) {
            print("Error: \(error)")
        } else {
            if let error = chirp?.start() {
                print("Error: \(error)")
            } else {
                print("Chirp enabled.")
            }
        }
    }

    func sendChirp(withMessage message: String, completionHandler: ((Bool, Error?) -> Void)) {
        guard let payload = message.data(using: .utf8) else {
            completionHandler(false, nil)
            return
        }
        if let error = chirp?.send(payload) {
            completionHandler(false, error)
            
        } else {
            completionHandler(true, nil)
        }
    }
}
