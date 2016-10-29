//
//  Document.swift
//  ReaderKit
//
//  Created by chocoyama on 2016/10/27.
//  Copyright © 2016年 chocoyama. All rights reserved.
//

import Foundation

public protocol Document {
    var documentTitle: String { get }
    var documentLink: URL { get }
    var documentItems: [DocumentItem] { get }
    static func create(from data: Data, url: URL) -> Self
}

public struct DocumentItem {
    let title: String
    let link: URL?
    let description: String
    let date: String
    
    // Urlのみ
    var nonFetchedImages: [Image] {
        guard let link = link else {
            return []
        }
        let scrapingService = ScrapingService.init(with: link)
        let images = scrapingService.getImages()
        return images
    }
}

public enum DocumentType {
    case rss1_0
    case rss2_0
    case atom
    
    func parse(data: Data, url: URL) -> Document {
        switch self {
        case .rss1_0: return RSS1_0.create(from: data, url: url)
        case .rss2_0: return RSS2_0.create(from: data, url: url)
        case .atom: return ATOM.create(from: data, url: url)
        }
    }
}
