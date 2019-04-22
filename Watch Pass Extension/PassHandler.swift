//
//  PassHandler.swift
//  Watch Pass Extension
//
//  Created by Jose Aguilar on 4/21/19.
//  Copyright © 2019 Jose Aguilar. All rights reserved.
//

import WatchKit

class PassHandler {
    /// Stores the image recieved from the iOS app in the local documents directory.
    static func storeToFileManager(fromURL: URL) {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { fatalError() }

        do {
            let imageData = try Data(contentsOf: fromURL)
            let fileName = "currentPass"
            let fileURL = documentsDirectory.appendingPathComponent(fileName)

            if FileManager.default.fileExists(atPath: fileURL.path) {
                do {
                    try FileManager.default.removeItem(atPath: fileURL.path)
                } catch {
                    print(error)
                }
            }

            try imageData.write(to: fileURL)
        } catch {
            print(error)
        }
    }

    /// Localy stores the dictionary passed from the iOS app.
    static func storeToDefaults(passInfo: [String: Any]) {
        let defaults = UserDefaults.standard
        defaults.set(passInfo["title"] as? String, forKey: "title")
        defaults.set(passInfo["code"] as? String, forKey: "code")
    }

    static func retrievePassData() -> Data? {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { fatalError() }

        let fileName = "currentPass"
        let fileURL = documentsDirectory.appendingPathComponent(fileName)

        do {
            let imageData = try Data(contentsOf: fileURL)
            return imageData
        } catch {
            print(error)
        }
        return nil
    }

    enum DefaultsKeys: String {
        case title
        case code
    }

    static func retrieveFromDefaults(withKey key: DefaultsKeys) -> Any? {
        let defaults = UserDefaults.standard
        return defaults.value(forKey: key.rawValue)
    }
}
