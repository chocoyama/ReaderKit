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
        return RealmManager.checkSubscribed(document: self)
    }
    
    public func subscribe() -> Bool {
        return RealmManager.subscribe(document: self)
        
    }
    
    public func unSubscribe() -> Bool {
        return RealmManager.unSubscribe(document: self)
        
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
