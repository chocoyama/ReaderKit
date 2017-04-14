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
    
    public func toRealmObject() -> RealmDocument {
        let realmItems = items.map{ $0.toRealmObject() }
        let realmDoc = RealmDocument(value: [
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
