//
//  RSS2_0.swift
//  ReaderKit
//
//  Created by chocoyama on 2016/10/27.
//  Copyright © 2016年 chocoyama. All rights reserved.
//

import Foundation
import SwiftyXMLParser

public struct RSS2_0: Documentable {
    struct Channel {
        struct Item {
            let title: String
            let link: URL
            let desc: String
            let pubDate: Date
        }
        
        let title: String
        let link: URL
        let desc: String
        let items: [Item]
    }
    
    let channel: Channel
    
    // MARK:- Document Protocol
    
    public var documentTitle: String {
        return channel.title
    }
    
    public var documentLink: URL {
        return channel.link
    }
    
    public var documentItems: [Document.Item] {
        return channel.items.map {
            Document.Item(
                documentTitle: documentTitle,
                documentLink: documentLink,
                title: $0.title,
                link: $0.link,
                desc: $0.desc,
                date: $0.pubDate,
                read: false
            )
        }
    }
    
    public static var dateFormat: String {
        return "EEE, dd MMM yyyy HH:mm:ss ZZZZ"
    }
    
    public static func create(from data: Data, url: URL) -> RSS2_0 {
        let xml = XML.parse(data)
        let channelXml = xml[["rss", "channel"]]
        
        var items: [RSS2_0.Channel.Item] = []
        channelXml["item"].forEach {
            let link = $0["link"].text.flatMap{ URL(string: $0) }
            if let link = link {
                let item = RSS2_0.Channel.Item(
                    title: $0["title"].text ?? "",
                    link: link,
                    desc: $0["description"].text ?? "",
                    pubDate: $0["pubDate"].text?.toDate(format: self.dateFormat) ?? Date.init()
                )
                items.append(item)
            }
        }
        
        let channel = RSS2_0.Channel(
            title: channelXml["title"].text ?? "",
            link: url,
            desc: channelXml["description"].text ?? "",
            items: items
        )
        
        let rss2_0 = RSS2_0(channel: channel)
        return rss2_0
    }
}
