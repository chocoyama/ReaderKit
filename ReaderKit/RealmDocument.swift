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
    
    dynamic var id = ""
    dynamic var title = ""
    dynamic var link = ""
    let items = List<RealmDocumentItem>()
    
    override public static func primaryKey() -> String? {
        return "id"
    }
    
    override public static func indexedProperties() -> [String] {
        return ["id"]
    }
    
    
    // WARNING:- 重たい処理
    func toDocument() -> Document? {
        guard let url = URL(string: link) else { return nil }
        return Document.init(title: title, link: url, items: documentItems)
    }
    
    func toDocumentSummary() -> Document.Summary? {
        guard let link = URL.init(string: link) else { return nil }
        
        var unreadCount = 0
        items.forEach { if $0.read == false { unreadCount += 1 } }
        
        var lastUpdated = items.first?.date
        items.forEach{
            if let unwrappedlastUpdated = lastUpdated, $0.date > unwrappedlastUpdated {
                lastUpdated = $0.date
            }
        }
        
        return Document.Summary.init(
            id: id,
            title: title,
            link: link,
            itemCount: items.count,
            unreadCount: unreadCount,
            lastUpdated: lastUpdated
        )
    }
    
    var itemIds: [String] {
        return items.map{ $0.id }
    }
    
    private var documentItems: [DocumentItem] {
        var result: [DocumentItem] = []
        items.forEach {
            if let documentItem = $0.toDocumentItem() {
                result.append(documentItem)
            }
        }
        return result
    }
}

