//
//  Reader.swift
//  ReaderKit
//
//  Created by chocoyama on 2016/10/27.
//  Copyright © 2016年 chocoyama. All rights reserved.
//

import Foundation

open class Reader {
    
    private let documentProvider = DocumentProvider.init()
    private let configuration: Configuration
    
    public init(with configuration: Configuration = .default) {
        self.configuration = configuration
    }
    
    open func read(_ url: URL, handler: @escaping (_ document: Document?, _ error: Error?) -> Void) {
        documentProvider.get(from: url) { (document, error) in
            DispatchQueue.main.async {
                handler(document, error)
            }
        }
    }
    
    open func readNew(_ url: URL, handler: @escaping (_ document: Document?, _ error: Error?) -> Void) {
        documentProvider.getNewArrival(from: url) { (document, error) in
            DispatchQueue.main.async {
                handler(document, error)
            }
        }
    }
    
    open func choices(from url: URL) -> [Choice] {
        let extractor = Extractor()
        let choices = extractor.extractChoices(from: url)
        return choices
    }
    
    open func next(handler: (_ document: Documentable?, _ items: [DocumentItem], _ error: Error?) -> Void) {
        
    }
    
}
