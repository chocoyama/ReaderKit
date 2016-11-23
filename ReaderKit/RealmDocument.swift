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
    
    func toDocument() -> Document? {
        guard let url = URL(string: link) else { return nil }
        return Document.init(title: title, link: url, items: documentItems)
    }
    
    func toDocumentSummary() -> DocumentSummary? {
        guard let link = URL.init(string: link) else { return nil }
        
        var unreadCount = 0
        items.forEach { if $0.read == false { unreadCount += 1 } }
        
        var lastUpdated = items.first?.date
        items.forEach{
            if let unwrappedlastUpdated = lastUpdated, $0.date > unwrappedlastUpdated {
                lastUpdated = $0.date
            }
        }
        
        return DocumentSummary.init(
            id: id,
            title: title,
            link: link,
            itemCount: items.count,
            unreadCount: unreadCount,
            lastUpdated: lastUpdated
        )
    }
    
    var itemIds: [String] {
        return documentItems.map{ $0.id }
    }
    
    private var documentItems: [Document.Item] {
        var result: [Document.Item] = []
        items.forEach {
            if let documentItem = $0.toDocumentItem() {
                result.append(documentItem)
            }
        }
        return result
    }
}

public class RealmDocumentItem: Object {
    
    dynamic var id = ""
    dynamic var documentTitle = ""
    dynamic var documentLink = ""
    dynamic var title = ""
    dynamic var link = ""
    dynamic var desc = ""
    dynamic var date = Date.init()
    dynamic var read = false
    
    override public static func primaryKey() -> String? {
        return "id"
    }
    
    override public static func indexedProperties() -> [String] {
        return ["id"]
    }
    
    func toDocumentItem() -> Document.Item? {
        guard let link = URL(string: link),
            let documentLink = URL(string: documentLink) else {
            return nil
        }
        
        return Document.Item(
            documentTitle: documentTitle,
            documentLink: documentLink,
            title: title,
            link: link,
            desc: desc,
            date: date,
            read: read
        )
    }
}

