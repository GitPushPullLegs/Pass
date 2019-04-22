//
//  WatchHandler.swift
//  Pass
//
//  Created by Jose Aguilar on 4/21/19.
//  Copyright © 2019 Jose Aguilar. All rights reserved.
//

import UIKit
import WatchConnectivity

class WatchHandler: NSObject, WCSessionDelegate {

    static let shared = WatchHandler()

    private let session = WCSession.default

    private override init() {
        super.init()
        session.delegate = self
        session.activate()
    }

    static var isSupported: Bool {
        return WCSession.isSupported()
    }

    var isPaired: Bool {
        return session.isPaired
    }

    var isInstalled: Bool {
        return session.isWatchAppInstalled
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        switch activationState {
        case .activated:
            print("Activated session")
        case .inactive:
            print("Inactive session")
        case .notActivated:
            print("Not activated session")
        }
    }

    func sessionDidBecomeInactive(_ session: WCSession) {
        print("Inactive")
    }

    func sessionDidDeactivate(_ session: WCSession) {
        print("Deactivate")
    }

    func sendPassDataToWatch(file: URL, metadata: [String: Any]?) {
        session.transferFile(file, metadata: metadata)
    }

    func session(_ session: WCSession, didFinish fileTransfer: WCSessionFileTransfer, error: Error?) {
        if let error = error {
            print(error)
        }

        print("Triggered fileTransfer didFinish method.")
    }
}
