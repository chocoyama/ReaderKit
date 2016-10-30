//
//  DetectService.swift
//  ReaderKit
//
//  Created by chocoyama on 2016/10/28.
//  Copyright © 2016年 chocoyama. All rights reserved.
//

import Foundation
import Ji

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
    
    func extractFeedUrl(from htmlData: Data) -> URL? {
        let jiDoc = Ji(htmlData: htmlData)
        
        var atomUrlString: String?
        var rssUrlString: String?
        
        jiDoc?.xPath("//link")?.forEach {
            switch $0.attributes["type"] {
            case .some("application/atom+xml"):
                atomUrlString = $0.attributes["href"]
            case .some("application/rss+xml"):
                rssUrlString = $0.attributes["href"]
            default: break
            }
        }
        
        // linkにrssが設定されていなかった場合、本文にアンカーで貼ってある場合がある。
        if atomUrlString == nil && rssUrlString == nil {
            jiDoc?.xPath("//a")?.forEach {
                let href = $0.attributes["href"]
                if href?.hasSuffix("rss.xml") == true {
                    rssUrlString = href
                }
            }
        }
        
        if let atomUrlString = atomUrlString, let atomUrl = URL(string: atomUrlString) {
            return atomUrl
        } else if let rssUrlString = rssUrlString, let rssUrl = URL(string: rssUrlString) {
            return rssUrl
        } else {
            return nil
        }
    }
}
