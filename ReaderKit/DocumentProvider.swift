//
//  DocumentProvider.swift
//  ReaderKit
//
//  Created by chocoyama on 2016/10/28.
//  Copyright © 2016年 chocoyama. All rights reserved.
//

import Foundation

open class DocumentProvider {
    
    private let session = URLSession.shared
    private var task: URLSessionDataTask?
    
    deinit {
        task?.cancel()
    }
    
    func get(from url: URL, handler: @escaping (_ document: Document?, _ error: Error?) -> Void) {
        task = session.dataTask(with: URLRequest(url: url)) { [weak self] (data, response, error) in
            if let error = error {
                handler(nil, error)
                return
            }
            
            guard let data = data, let response = response else {
                handler(nil, NSError.init(domain: "", code: 0, userInfo: nil))
                return
            }
            
            
            if let document = self?.createDocument(from: data, response: response) {
                handler(document, nil)
            } else {
                handler(nil, NSError.init(domain: "", code: 0, userInfo: nil))
            }
        }
        task?.resume()
    }
    
    private func createDocument(from data: Data, response: URLResponse) -> Document? {
        let detectService = DetectService.init()
        let isXml = detectService.determineXmlType(from: response)
        
        if isXml {
            let feedData = data
            let documentType = detectService.determineDocumentType(from: feedData)
            if let url = response.url {
                return documentType?.parse(data: feedData, url: url)
            } else {
                return nil
            }
        } else {
            let htmlData = data
            // TODO: Dataの初期化でパフォーマンス落ちる
            if let url = detectService.extractFeedUrl(from: htmlData),
                let data = try? Data.init(contentsOf: url) {
                let documentType = detectService.determineDocumentType(from: data)
                let document = documentType?.parse(data: data, url: url)
                return document
            } else {
                return nil
            }
        }
    }
}
