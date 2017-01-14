//
//  Scraper.swift
//  ScrapingKit
//
//  Created by takyokoy on 2017/01/08.
//  Copyright © 2017年 chocoyama. All rights reserved.
//

import Foundation
import ImageDissector

open class Scraper<T: Parser> {

    private var parser = T()
    
    public init() {}

    open func scrape(_ url: URL, completion: @escaping (T.Result) -> Void) {
        parser.parse(url)
        parser.getResult{ (result) in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }

    open func scrape(_ url: String, completion: @escaping (T.Result) -> Void) {
        DispatchQueue.global().async { [weak self] in
            let url = URL.init(string: url)!
            self?.scrape(url, completion: completion)
        }
    }

    open func setConfiguration(_ config: T.Configuration) {
        parser.configuration = config
    }
    
}


