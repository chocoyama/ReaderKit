//
//  Document+RealmExtension.swift
//  ReaderKit
//
//  Created by chocoyama on 2016/10/31.
//  Copyright © 2016年 chocoyama. All rights reserved.
//

import Foundation
import RealmSwift

extension Document {
    public var subscribed: Bool {
        do {
            let realm = try Realm()
            let result = realm.objects(RealmDocument.self).filter("link = '\(link.absoluteString)'")
            return result.count != 0
        } catch let error {
            print(error)
            return false
        }
    }
    
    public func subscribe() throws {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(self.toRealmObject(), update: true)
            }
        } catch let error {
            print(error)
            throw error
        }
    }
    
    public func unSubscribe() throws {
        do {
            let realm = try Realm()
            let result = realm.objects(RealmDocument.self).filter("link = '\(link.absoluteString)'")
            try realm.write {
                realm.delete(result)
            }
        } catch let error {
            print(error)
            throw error
        }
    }
    
    public func toRealmObject() -> RealmDocument {
        let realmItems = items.map{ $0.toRealmObject() }
        let realmDoc = RealmDocument.init(value: [
            "id": id,
            "title": title,
            "link": link.absoluteString,
            "items": realmItems
            ])
        return realmDoc
    }
    
    public var realmItems: [RealmDocumentItem] {
        return items.map { $0.toRealmObject() }
    }
}

extension DocumentItem {
    func toRealmObject() -> RealmDocumentItem {
        let realmItem = RealmDocumentItem()
        realmItem.id = id
        realmItem.title = title
        realmItem.link = link.absoluteString
        realmItem.desc = desc
        realmItem.date = date
        return realmItem
    }
}
