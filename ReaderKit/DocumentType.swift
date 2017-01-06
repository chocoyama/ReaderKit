//
//  DocumentType.swift
//  ReaderKit
//
//  Created by takyokoy on 2017/01/05.
//  Copyright © 2017年 chocoyama. All rights reserved.
//

import Foundation

public enum DocumentType {
    case rss1_0
    case rss2_0
    case atom
    
    func parse(data: Data, url: URL) -> Documentable {
        switch self {
        case .rss1_0: return RSS1_0.create(from: data, url: url)
        case .rss2_0: return RSS2_0.create(from: data, url: url)
        case .atom: return ATOM.create(from: data, url: url)
        }
    }
}
