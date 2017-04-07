//
//  RealmManager.swift
//  ReaderKit
//
//  Created by takyokoy on 2017/01/05.
//  Copyright © 2017年 chocoyama. All rights reserved.
//

import Foundation
import RealmSwift

internal struct RealmHelper {
    static func create() -> Realm? {
        do {
            let realm = try Realm()
            return realm
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
    
    static func deleteAll() -> Bool {
        guard let realm = create() else { return false }
        Realm.Configuration.defaultConfiguration.deleteRealmIfMigrationNeeded = true
        return write(realm) {
            realm.deleteAll()
        }
    }
    
    static func write(process: () -> Void) -> Bool {
        guard let realm = create() else { return false }
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
    
    static func write(_ realm: Realm, process: () -> Void) -> Bool {
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

