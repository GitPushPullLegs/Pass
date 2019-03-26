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
    //IMPORTANT: - Remember to update VariableKey enum
    @objc dynamic var title = ""
    @objc dynamic var code = ""
    @objc dynamic var isCode39 = false
    @objc dynamic var isOnWatch = false
    @objc dynamic var isOnWidget = false

    // Ignored Properties
    var image: UIImage {
        return UIImage() //TODO: - Return actual image.
    }

    convenience init(title: String, code: String, isCode39: Bool) {
        self.init()
        self.title = title
        self.code = code
        self.isCode39 = isCode39
    }
}

//MARK: - Setters
extension PassM {
    enum VariableKey: String {
        case title, code, isCode39, isOnWatch, isOnWidget
    }

    func setValue(_ value: Any, forKey key: VariableKey) throws {
        do {
            let realm = try Realm()
            try realm.write {
                self.setValue(value, forKeyPath: key.rawValue)
            }
        } catch {
            throw error
        }
    }

    func setValues(_ keyedValues: [VariableKey: Any]) throws {
        do {
            let realm = try Realm()
            try realm.write {
                for each in keyedValues {
                    self.setValue(each.value, forKeyPath: each.key.rawValue)
                }
            }
        } catch {
            throw error
        }
    }
}

extension PassM {
    func deleteSelf(completion: ((Bool, Error?) -> Void)) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.delete(self)
            }
            completion(true, nil)
        } catch {
            completion(false, error)
        }
    }
}
