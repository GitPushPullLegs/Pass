//
//  RealmProtocol.swift
//  Pass
//
//  Created by Jose Aguilar on 3/25/19.
//  Copyright © 2019 Jose Aguilar. All rights reserved.
//

import UIKit
import RealmSwift

protocol RealmProtocol {
    func generatePass(title: String, code: String, isCode39: Bool) -> PassM
    func savePass(_ pass: PassM) throws
}

extension RealmProtocol {
    func generatePass(title: String, code: String, isCode39: Bool) -> PassM {
        let pass = PassM()
        pass.title = title
        pass.code = code
        pass.isCode39 = isCode39
        return pass
    }

    func savePass(_ pass: PassM) throws {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(pass)
            }
        } catch {
            throw error
        }
    }
}
