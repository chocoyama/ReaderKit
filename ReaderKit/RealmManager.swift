//
//  RealmManager.swift
//  ReaderKit
//
//  Created by takyokoy on 2017/01/05.
//  Copyright © 2017年 chocoyama. All rights reserved.
//

import Foundation
import RealmSwift

internal class RealmManager {
    class func makeRealm() -> Realm? {
        do {
            let realm = try Realm()
            return realm
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
    
    class func write(realm: Realm, process: () -> Void) -> Bool {
        do {
            try realm.write {
                process()
            }
            return true
        } catch let error {
            print(error.localizedDescription)
            return false
        }
    }
}
