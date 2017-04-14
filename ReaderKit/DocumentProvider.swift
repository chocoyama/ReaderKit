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
        task = session.dataTask(with: URLRequest(url: url)) { (data, response, error) in
            if let error = error {
                handler(nil, error)
                return
            }
            
            guard let data = data, let response = response else {
                handler(nil, NSError.init(domain: "", code: 0, userInfo: nil))
                return
            }
            
            let document = DocumentFactory().createDocument(from: data, response: response)
            let error = (document == nil) ? NSError.init(domain: "", code: 0, userInfo: nil) : nil
            handler(document, error)
        }
        task?.resume()
    }
    
    func getNewArrival(from url: URL, handler: @escaping (_ document: Document?, _ error: Error?) -> Void) {
        task = session.dataTask(with: URLRequest(url: url)) { (data, response, error) in
            if let error = error {
                handler(nil, error)
                return
            }
            
            guard let data = data, let response = response else {
                handler(nil, NSError.init(domain: "", code: 0, userInfo: nil))
                return
            }
            
            let document = DocumentFactory().createDiffDocument(from: data, response: response)
            let error = (document == nil) ? NSError.init(domain: "", code: 0, userInfo: nil) : nil
            handler(document, error)
        }
        task?.resume()
    }
    
}


