//
//  RSS1_0.swift
//  ReaderKit
//
//  Created by chocoyama on 2016/10/27.
//  Copyright © 2016年 chocoyama. All rights reserved.
//

import Foundation
import SwiftyXMLParser

public struct RSS1_0: Documentable {
    struct Channel {
        let title: String
        let link: URL
        let desc: String
        let date: Date
        let language: String
    }
    
    struct Item {
        let title: String
        let link: URL
        let desc: String
        let creator: String
        let date: Date
    }
    
    let channel: Channel
    let items: [Item]
    
    // MARK:- Document Protocol
     public var documentTitle: String {
        return channel.title
    }
    
    public var documentLink: URL {
        return channel.link
    }
    
    public var documentItems: [DocumentItem] {
        return items.map {
            let item = DocumentItem()
            item.documentTitle = documentTitle
            item.documentLink = documentLink.absoluteString
            item.title = $0.title
            item.link = $0.link.absoluteString
            item.desc = $0.desc
            item.date = $0.date
            item.read = false
            return item
        }
    }
    
    public static var dateFormat: String {
        return "yyyy-MM-dd'T'HH:mm:ssZ"
    }
    
    public static func create(from data: Data, url: URL) -> RSS1_0 {
        let xml = XML.parse(data)
        let channelXml = xml[["rdf:RDF", "channel"]]
        let channel = RSS1_0.Channel(
            title: channelXml["title"].text ?? "",
            link: url,
            desc: channelXml["description"].text ?? "",
            date: channelXml["dc:date"].text?.toDate(format: self.dateFormat) ?? Date.init(),
            language: channelXml["dc:language"].text ?? ""
        )
        
        var items: [RSS1_0.Item] = []
        xml[["rdf:RDF", "item"]].forEach {
            let link = $0["link"].text.flatMap{ URL(string: $0) }
            if let link = link {
                let item = RSS1_0.Item(
                    title: $0["title"].text ?? "",
                    link: link,
                    desc: $0["description"].text ?? "",
                    creator: $0["dc:creator"].text ?? "",
                    date: $0["dc:date"].text?.toDate(format: self.dateFormat) ?? Date.init()
                )
                items.append(item)
            }
        }
        
        let rss1_0 = RSS1_0(channel: channel, items: items)
        return rss1_0
    }
}

