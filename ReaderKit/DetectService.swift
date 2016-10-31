//
//  DetectService.swift
//  ReaderKit
//
//  Created by chocoyama on 2016/10/28.
//  Copyright © 2016年 chocoyama. All rights reserved.
//

import Foundation
import Ji

public struct Choice {
    public let url: URL
    public let title: String
}

open class DetectService {
    
    func determineXmlType(from response: URLResponse) -> Bool {
        guard let mimeType = response.mimeType else {
            return false
        }
        
        return [
            "application/atom+xml",
            "application/rss+xml",
            "application/rdf+xml",
            "application/xml"
        ].filter{ $0 == mimeType }.count > 0
    }
    
    func determineDocumentType(from feedUrl: URL) -> DocumentType? {
        let jiDoc = Ji(contentsOfURL: feedUrl, isXML: false)
        return determineDocumentType(from: jiDoc)
    }
    
    func determineDocumentType(from feedData: Data) -> DocumentType? {
        let jiDoc = Ji(data: feedData, isXML: false)
        return determineDocumentType(from: jiDoc)
    }
    
    private func determineDocumentType(from jiDoc: Ji?) -> DocumentType? {
        if let entryCount = jiDoc?.xPath("//entry")?.count, entryCount > 0 {
            return .atom
        } else if let channelItemCount = jiDoc?.xPath("//channel/item")?.count, channelItemCount > 0 {
            return .rss2_0
        } else if let itemCount = jiDoc?.xPath("//item")?.count, itemCount > 0 {
            return .rss1_0
        } else {
            return nil
        }
    }
    
    func extractChoices(from url: URL) -> [Choice] {
        guard let data = try? Data(contentsOf: url) else {
            return []
        }
        let jiDoc = Ji(data: data, encoding: .utf8, isXML: false)
        if let _ = determineDocumentType(from: jiDoc) {
            let title = jiDoc?.xPath("//title")?.first?.content ?? ""
            return [Choice.init(url: url, title: title)]
        }
        return extractChoices(from: data)
    }
    
    private func extractChoices(from htmlData: Data) -> [Choice] {
        let jiDoc = Ji(htmlData: htmlData)
        
        var choices = [Choice]()
        jiDoc?.xPath("//link")?.forEach {
            switch $0.attributes["type"] {
            case .some("application/atom+xml"), .some("application/rss+xml"):
                if let href = $0.attributes["href"], let url = URL(string: href) {
                    choices.append(.init(url: url, title: $0.attributes["title"] ?? ""))
                }
            default: break
            }
        }
        
        jiDoc?.xPath("//a")?.forEach {
            if let href = $0.attributes["href"],
                href.hasSuffix("rss.xml"),
                let url = URL(string: href) {
                choices.append(.init(url: url, title: ""))
            }
        }
        
        return choices
    }
    
    func extractFeedUrl(from htmlData: Data) -> URL? {
        let choice = extractChoices(from: htmlData)
        return choice.first?.url
    }
}
