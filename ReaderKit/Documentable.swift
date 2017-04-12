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
        let document = Document()
        document.title = documentTitle
        document.link = documentLink.absoluteString
        document.items.append(objectsIn: documentItems)
        return document
    }
    
    
    /// DBに保存されているDocumentItemと同様の情報は除外した上でDocumentオブジェクトを作成する
    ///
    /// - Returns: Documentオブジェクト
    func toDiffDocument() -> Document {
        let storedDocument = DocumentRepository.shared.get(documentLink.absoluteString)
        let storedLinks = storedDocument?.itemLinks
        let newDocumentItems = documentItems.filter{ storedLinks?.contains($0.link) == false }
        
        let document = Document()
        document.title = documentTitle
        document.link = documentLink.absoluteString
        document.items.append(objectsIn: newDocumentItems)
        return document
    }
}
