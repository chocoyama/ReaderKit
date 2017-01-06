//
//  DocumentItem+RealmExtension.swift
//  ReaderKit
//
//  Created by takyokoy on 2017/01/05.
//  Copyright © 2017年 chocoyama. All rights reserved.
//

import Foundation
import RealmSwift

extension DocumentItem {
    func toRealmObject() -> RealmDocumentItem {
        let realmItem = RealmDocumentItem()
        realmItem.id = id
        realmItem.documentTitle = documentTitle
        realmItem.documentLink = documentLink.absoluteString
        realmItem.title = title
        realmItem.link = link.absoluteString
        realmItem.desc = desc
        realmItem.date = date
        realmItem.read = read
        return realmItem
    }
    
    func getReadFlag() -> Bool {
        return RealmManager.checkRead(item: self)
    }
    
    func setReadFlag(_ read: Bool) -> Bool {
        return RealmManager.setRead(isRead: read, item: self)
    }
}
