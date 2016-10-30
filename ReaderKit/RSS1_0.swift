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
        let date: String
        let language: String
    }
    
    struct Item {
        let title: String
        let link: URL
        let desc: String
        let creator: String
        let date: String
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
            DocumentItem(
                title: $0.title,
                link: $0.link,
                desc: $0.desc,
                date: $0.date
            )
        }
    }
    
    public static func create(from data: Data, url: URL) -> RSS1_0 {
        let xml = XML.parse(data)
        let channelXml = xml[["rdf:RDF", "channel"]]
        let channel = RSS1_0.Channel(
            title: channelXml["title"].text ?? "",
            link: url,
            desc: channelXml["description"].text ?? "",
            date: channelXml["dc:date"].text ?? "",
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
                    date: $0["dc:date"].text ?? ""
                )
                items.append(item)
            }
        }
        
        let rss1_0 = RSS1_0(channel: channel, items: items)
        return rss1_0
    }
}

