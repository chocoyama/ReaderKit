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
        guard let url = URL(string: link) else {
            return nil
        }
        return Document.init(title: title, link: url, items: documentItems)
    }
    
    var itemIds: [String] {
        return documentItems.map{ $0.id }
    }
    
    private var documentItems: [DocumentItem] {
        var result = [DocumentItem]()
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
    dynamic var title = ""
    dynamic var link = ""
    dynamic var desc = ""
    dynamic var date = ""
    
    override public static func primaryKey() -> String? {
        return "id"
    }
    
    override public static func indexedProperties() -> [String] {
        return ["id"]
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

