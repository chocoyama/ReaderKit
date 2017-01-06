//
//  DoctypeDetector.swift
//  ReaderKit
//
//  Created by takyokoy on 2017/01/06.
//  Copyright © 2017年 chocoyama. All rights reserved.
//

import Foundation
import Ji

open class Detector {
    
    // MARK:- open
    
    open func determineXmlType(from response: URLResponse) -> Bool {
        guard let mimeType = response.mimeType else { return false }
        
        return [
            "application/atom+xml",
            "application/rss+xml",
            "application/rdf+xml",
            "application/xml"
            ].filter{ $0 == mimeType }.count > 0
    }
    
    open func determineDocumentType(from feedUrl: URL) -> DocumentType? {
        let jiDoc = Ji(contentsOfURL: feedUrl, isXML: false)
        return determineDocumentType(from: jiDoc)
    }
    
    open func determineDocumentType(from feedData: Data) -> DocumentType? {
        let jiDoc = Ji(data: feedData, isXML: false)
        return determineDocumentType(from: jiDoc)
    }
    
    // MARK:- internal
    
    internal func determineDocumentType(from jiDoc: Ji?) -> DocumentType? {
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
}
