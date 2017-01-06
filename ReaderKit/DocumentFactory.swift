//
//  DocumentFactory.swift
//  ReaderKit
//
//  Created by takyokoy on 2017/01/05.
//  Copyright © 2017年 chocoyama. All rights reserved.
//

import Foundation

open class DocumentFactory {
    
    private let detectService = DetectService()
    private let extractService = ExtractService()
    
    open func createDocument(from data: Data, response: URLResponse) -> Document? {
        let documentable = createDocumentable(from: data, response: response)
        return documentable?.toDocument()
    }
    
    open func createDocumentable(from data: Data, response: URLResponse) -> Documentable? {
        let isXml = detectService.determineXmlType(from: response)
        return isXml ? create(fromXmlData: data, response: response) : create(fromHtmlData: data, response: response)
    }
    
    private func create(fromXmlData xmlData: Data, response: URLResponse) -> Documentable? {
        guard let url = response.url else { return nil }
        let documentType = detectService.determineDocumentType(from: xmlData)
        return documentType?.parse(data: xmlData, url: url)
    }
    
    private func create(fromHtmlData htmlData: Data, response: URLResponse) -> Documentable? {
        // TODO: Dataの初期化でパフォーマンス落ちる
        guard let url = extractService.extractFeedUrl(from: htmlData),
            let data = try? Data.init(contentsOf: url) else {
                return nil
        }
        let documentType = detectService.determineDocumentType(from: data)
        return documentType?.parse(data: data, url: url)
    }
    
}
