//
//  ATOM.swift
//  ReaderKit
//
//  Created by chocoyama on 2016/10/27.
//  Copyright © 2016年 chocoyama. All rights reserved.
//

import Foundation
import SwiftyXMLParser

public struct ATOM: Documentable {
    struct Feed {
        struct Entry {
            let id: String
            let title: String
            let link: URL
            let updated: Date
            let summary: String
        }
        
        let id: String
        let title: String
        let updated: Date
        let siteLink: URL?
        let feedLink: URL
        let entries: [Entry]
    }
    
    let feed: Feed
    
    // MARK:- Document Protocol
    
    public var documentTitle: String {
        return feed.title
    }
    
    public var documentLink: URL {
        return feed.feedLink
    }
    
    public var documentItems: [Document.Item] {
        return feed.entries.map {
            Document.Item(
                documentTitle: documentTitle,
                documentLink: documentLink,
                title: $0.title,
                link: $0.link,
                desc: $0.summary,
                date: $0.updated,
                read: false
            )
        }
    }
    
    public static var dateFormat: String {
        return "yyyy-MM-dd'T'HH:mm:ssZ"
    }
    
    public static func create(from data: Data, url: URL) -> ATOM {
        let xml = XML.parse(data)
        let feedXml = xml[["feed"]]
        
        let siteLinkText = feedXml["link"].filter{ $0.attributes["rel"] == "alternate" }.flatMap{ $0.attributes["href"] }.first ?? feedXml["link"].attributes["href"]
        let siteLink = siteLinkText.flatMap{ URL(string: $0) }
        
        var entries: [ATOM.Feed.Entry] = []
        feedXml["entry"].forEach {
            let linkText = $0["link"].flatMap{ $0.attributes["href"] }.first
            let link = linkText.flatMap{ URL(string: $0) }
            if let link = link {
                let entry = ATOM.Feed.Entry(
                    id: $0["id"].text ?? "",
                    title: $0["title"].text ?? "",
                    link: link,
                    updated: $0["updated"].text?.toDate(format: self.dateFormat) ?? Date.init(),
                    summary: $0["summary"].text ?? ""
                )
                entries.append(entry)
            }
        }
        
        let feed = ATOM.Feed(
            id: feedXml["id"].text ?? "",
            title: feedXml["title"].text ?? "",
            updated: feedXml["updated"].text?.toDate(format: self.dateFormat) ?? Date.init(),
            siteLink: siteLink,
            feedLink: url,
            entries: entries
        )
        
        let atom = ATOM(feed: feed)
        return atom
    }
}
