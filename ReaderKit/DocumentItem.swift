//
//  RealmDocumentItem.swift
//  ReaderKit
//
//  Created by takyokoy on 2017/01/05.
//  Copyright © 2017年 chocoyama. All rights reserved.
//

import Foundation
import RealmSwift
import Realm
import ScrapingKit

open class DocumentItem: Object {
    open dynamic var documentTitle = ""
    open dynamic var documentLink = ""
    open dynamic var title = ""
    open dynamic var link = ""
    open dynamic var desc = ""
    open dynamic var date = Date.init()
    open dynamic var read = false
    
    private let scraper = Scraper<ImageParser>()
    
    override open static func primaryKey() -> String? {
        return "link"
    }
    
    override open static func indexedProperties() -> [String] {
        return ["link"]
    }
    
    // Urlのみ
    open func getImages(fetchSize: Bool, completion: @escaping ([SKImage]) -> Void) {
        let configuration = ImageParser.Configuration(fetchSize: true, exclusions: [])
        scraper.setConfiguration(configuration)
        scraper.scrape(link, completion: completion)
    }
}
