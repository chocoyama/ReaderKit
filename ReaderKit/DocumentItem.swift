//
//  Item.swift
//  ReaderKit
//
//  Created by takyokoy on 2017/01/05.
//  Copyright © 2017年 chocoyama. All rights reserved.
//

import Foundation
import ScrapingKit

public struct DocumentItem {
    public let id: String
    public let documentTitle: String
    public let documentLink: URL
    public let title: String
    public let link: URL
    public let desc: String
    public let date: Date
    public var read: Bool {
        get { return getReadFlag() }
        set { let _ = setReadFlag(newValue) }
    }
    
    private let scraper = Scraper<ImageParser>()
    
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
    public func getImages(fetchSize: Bool, completion: @escaping ([SKImage]) -> Void) {
        let configuration = ImageParser.Configuration(fetchSize: true, exclusions: [])
        scraper.setConfiguration(configuration)
        scraper.scrape(link, completion: completion)
    }
    
}
