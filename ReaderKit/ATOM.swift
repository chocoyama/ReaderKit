//
//  ATOM.swift
//  ReaderKit
//
//  Created by chocoyama on 2016/10/27.
//  Copyright © 2016年 chocoyama. All rights reserved.
//

import Foundation
import SwiftyXMLParser

public struct ATOM: Document {
    struct Feed {
        struct Entry {
            let id: String
            let title: String
            let link: URL
            let updated: String
            let summary: String
        }
        
        let id: String
        let title: String
        let updated: String
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
    
    public var documentItems: [DocumentItem] {
        return feed.entries.map {
            DocumentItem(
                title: $0.title,
                link: $0.link,
                description: $0.summary,
                date: $0.updated
            )
        }
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
                    updated: $0["updated"].text ?? "",
                    summary: $0["summary"].text ?? ""
                )
                entries.append(entry)
            }
        }
        
        let feed = ATOM.Feed(
            id: feedXml["id"].text ?? "",
            title: feedXml["title"].text ?? "",
            updated: feedXml["updated"].text ?? "",
            siteLink: siteLink,
            feedLink: url,
            entries: entries
        )
        
        let atom = ATOM(feed: feed)
        return atom
    }
}
