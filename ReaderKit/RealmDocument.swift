//
//  RealmDocument.swift
//  ReaderKit
//
//  Created by chocoyama on 2016/10/29.
//  Copyright © 2016年 chocoyama. All rights reserved.
//

import Foundation
import RealmSwift

public class RealmDocument: Object {
    
    dynamic var title = ""
    dynamic var link = ""
    let items = List<RealmDocumentItem>()
    
    override public static func primaryKey() -> String? {
        return "link"
    }
}

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
            "title": title,
            "link": link.absoluteString,
            "items": realmItems
            ])
        return realmDoc
    }
}

public class RealmDocumentItem: Object {
    dynamic var title = ""
    dynamic var link = ""
    dynamic var desc = ""
    dynamic var date = ""
    
    override public static func primaryKey() -> String? {
        return "link"
    }
    
    func toDocumentItem() -> DocumentItem? {
        guard let link = URL(string: link) else {
            return nil
        }
        
        return DocumentItem(
            title: title,
            link: link,
            desc: desc,
            date: date
        )
    }
}

extension DocumentItem {
    func toRealmObject() -> RealmDocumentItem {
        let realmItem = RealmDocumentItem()
        realmItem.title = title
        realmItem.link = link.absoluteString
        realmItem.desc = desc
        realmItem.date = date
        return realmItem
    }
}
