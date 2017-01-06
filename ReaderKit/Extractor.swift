//
//  Extractor.swift
//  ReaderKit
//
//  Created by takyokoy on 2017/01/06.
//  Copyright © 2017年 chocoyama. All rights reserved.
//

import Foundation
import Ji

class Extractor {
    
    private let detector = Detector()
    
    // MARK:- open
    
    open func extractChoices(from url: URL) -> [Choice] {
        guard let data = try? Data(contentsOf: url) else {
            return []
        }
        let jiDoc = Ji(data: data, encoding: .utf8, isXML: false)
        if let _ = detector.determineDocumentType(from: jiDoc) {
            let title = jiDoc?.xPath("//title")?.first?.content ?? ""
            return [Choice.init(url: url, title: title)]
        }
        return extractChoices(from: data)
    }
    
    open func extractFeedUrl(from htmlData: Data) -> URL? {
        let choice = extractChoices(from: htmlData)
        return choice.first?.url
    }
    
    // MARK:- private
    
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
}
