//
//  Document.swift
//  ReaderKit
//
//  Created by chocoyama on 2016/10/27.
//  Copyright © 2016年 chocoyama. All rights reserved.
//

import Foundation

public struct Document {
    
    public let id: String
    public let title: String
    public let link: URL
    public let items: [DocumentItem]
    
    init(title: String, link: URL, items: [DocumentItem]) {
        self.id = link.absoluteString
        self.title = title
        self.link = link
        self.items = items
    }
    
    public struct Summary {
        public let id: String
        public let title: String
        public let link: URL
        public let itemCount: Int
        public let unreadCount: Int
        public let lastUpdated: Date?
    }
    
    var summary: Summary {
        return Summary.init(
            id: id,
            title: title,
            link: link,
            itemCount: items.count,
            unreadCount: items.filter{ $0.read == false }.count,
            lastUpdated: items.sorted{ $0.0.date > $0.1.date }.first?.date
        )
    }
}
