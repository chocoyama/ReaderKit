//
//  RealmDocument.swift
//  ReaderKit
//
//  Created by chocoyama on 2016/10/29.
//  Copyright © 2016年 chocoyama. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

open class Document: Object {
    
    open dynamic var title = ""
    open dynamic var link = ""
    open let items = List<DocumentItem>()
    
    override open static func primaryKey() -> String? {
        return "link"
    }
    
    override open static func indexedProperties() -> [String] {
        return ["link"]
    }
    
    open var itemLinks: [String] {
        return items.map{ $0.link }
    }
    
    public struct Summary {
        public let title: String
        public let link: URL?
        public let itemCount: Int
        public let unreadCount: Int
        public let lastUpdated: Date?
    }
    
    open var summary: Summary {
        return Summary.init(
            title: title,
            link: URL(string: link),
            itemCount: items.count,
            unreadCount: items.filter{ $0.read == false }.count,
            lastUpdated: items.sorted{ $0.0.date > $0.1.date }.first?.date
        )
    }
    }

