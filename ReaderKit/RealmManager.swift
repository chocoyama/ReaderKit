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
    
    class func deleteAll() -> Bool {
        guard let realm = makeRealm() else { return false }
        Realm.Configuration.defaultConfiguration.deleteRealmIfMigrationNeeded = true
        return write(realm: realm) {
            realm.deleteAll()
        }
    }
}

extension RealmManager {
    
    class func getRealmDocumentResult() -> Results<RealmDocument>? {
        guard let realm = makeRealm() else { return nil }
        return realm.objects(RealmDocument.self)
    }
    
    class func getRealmDocumentItemResult() -> Results<RealmDocumentItem>? {
        guard let realm = makeRealm() else { return nil }
        return realm.objects(RealmDocumentItem.self)
    }
    
    class func getRealmDocument(from link: URL) -> RealmDocument? {
        return getRealmDocumentResult()?.filter("link = '\(link)'").first
    }
    
    class func getRealmDocumentItems(from: Int, to: Int) -> [RealmDocumentItem] {
        return getRealmDocumentItemResult()?
            .sorted(byKeyPath: "date", ascending: false)
            .enumerated()
            .filter({ (offset, element) -> Bool in
                return from <= offset && offset < to
            })
            .map{ $0.element }
            ?? []
    }
}

extension RealmManager {
    class func checkSubscribed(document: Document) -> Bool {
        guard let result = getRealmDocumentResult()?.filter("id = '\(document.id)'") else { return false }
        return result.count != 0
    }
    
    class func subscribe(document: Document) -> Bool {
        guard let realm = makeRealm() else { return false }
        return write(realm: realm, process: {
            realm.add(document.toRealmObject(), update: true)
        })
    }
    
    class func unSubscribe(document: Document) -> Bool {
        guard let realm = makeRealm(),
            let result = getRealmDocumentResult()?.filter("id = '\(document.id)'") else { return false }
        
        var isSucceeded = true
        for doc in result {
            isSucceeded = write(realm: realm, process: {
                realm.delete(doc.items)
            })
        }
        
        if isSucceeded == false {
            return false
        }
        
        return write(realm: realm) {
            realm.delete(result)
        }
    }
    
    class func checkRead(item: DocumentItem) -> Bool {
        return getRealmDocumentItemResult()?.filter("id = '\(item.id)'").first?.read ?? false
    }
    
    class func setRead(isRead: Bool, item: DocumentItem) -> Bool {
        guard let realm = makeRealm(),
            let savedItem = getRealmDocumentItemResult()?.filter("id = '\(item.id)'").first else { return false }
        return write(realm: realm) {
            savedItem.read = isRead
        }
    }
}
