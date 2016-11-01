//
//  Document.swift
//  ReaderKit
//
//  Created by chocoyama on 2016/10/27.
//  Copyright © 2016年 chocoyama. All rights reserved.
//

import Foundation

public protocol Documentable {
    var documentTitle: String { get }
    var documentLink: URL { get }
    var documentItems: [Document.Item] { get }
    static var dateFormat: String { get }
    static func create(from data: Data, url: URL) -> Self
}

extension Documentable {
    func toDocument() -> Document {
        return Document(
            title: documentTitle,
            link: documentLink,
            items: documentItems
        )
    }
}

public struct Document {
    public struct Item {
        public let id: String
        public let documentTitle: String
        public let documentLink: URL
        public let title: String
        public let link: URL
        public let desc: String
        public let date: Date
        public var read: Bool {
            get { return (try? getReadFlag()) ?? false }
            set { try? setReadFlag(read) }
        }
        
        init(documentTitle: String, documentLink: URL, title: String, link: URL, desc: String, date: Date, read: Bool) {
            self.id = link.absoluteString + documentLink.absoluteString
            self.documentTitle = documentTitle
            self.documentLink = documentLink
            self.title = title
            self.link = link
            self.desc = desc
            self.date = date
            self.read = read
        }
        
        // Urlのみ
        public var nonFetchedImages: [Image] {
            let scrapingService = ScrapingService.init(with: link)
            let images = scrapingService.getImages()
            return images
        }
        
    }
    
    public let id: String
    public let title: String
    public let link: URL
    public let items: [Document.Item]
    
    init(title: String, link: URL, items: [Document.Item]) {
        self.id = link.absoluteString
        self.title = title
        self.link = link
        self.items = items
    }
}
