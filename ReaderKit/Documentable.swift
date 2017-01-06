//
//  Documentable.swift
//  ReaderKit
//
//  Created by takyokoy on 2017/01/05.
//  Copyright © 2017年 chocoyama. All rights reserved.
//

import Foundation

public protocol Documentable {
    var documentTitle: String { get }
    var documentLink: URL { get }
    var documentItems: [DocumentItem] { get }
    static var dateFormat: String { get }
    static func create(from data: Data, url: URL) -> Self
}

extension Documentable {
    func toDocument() -> Document {
        return Document(
            title: documentTitle,
            link: documentLink,
            items: documentItems
        )
    }
}
