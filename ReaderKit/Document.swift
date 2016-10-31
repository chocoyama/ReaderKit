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
    var documentItems: [DocumentItem] { get }
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

public enum DocumentType {
    case rss1_0
    case rss2_0
    case atom
    
    func parse(data: Data, url: URL) -> Documentable {
        switch self {
        case .rss1_0: return RSS1_0.create(from: data, url: url)
        case .rss2_0: return RSS2_0.create(from: data, url: url)
        case .atom: return ATOM.create(from: data, url: url)
        }
    }
}

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
}

public struct DocumentItem {
    public let id: String
    public let title: String
    public let link: URL
    public let desc: String
    public let date: String
    
    init(title: String, link: URL, desc: String, date: String) {
        self.id = link.absoluteString + date
        self.title = title
        self.link = link
        self.desc = desc
        self.date = date
    }
    
    // Urlのみ
    public var nonFetchedImages: [Image] {
        let scrapingService = ScrapingService.init(with: link)
        let images = scrapingService.getImages()
        return images
    }
}
