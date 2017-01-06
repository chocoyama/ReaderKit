//
//  RealmDocumentItem.swift
//  ReaderKit
//
//  Created by takyokoy on 2017/01/05.
//  Copyright © 2017年 chocoyama. All rights reserved.
//

import Foundation
import RealmSwift

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
    
    func toDocumentItem() -> DocumentItem? {
        guard let link = URL(string: link),
            let documentLink = URL(string: documentLink) else {
                return nil
        }
        
        return DocumentItem(
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
