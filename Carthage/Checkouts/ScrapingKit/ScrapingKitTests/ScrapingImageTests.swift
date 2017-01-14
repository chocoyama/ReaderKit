//
//  ScrapingImageTests.swift
//  ScrapingKit
//
//  Created by takyokoy on 2017/01/08.
//  Copyright © 2017年 chocoyama. All rights reserved.
//

import XCTest
@testable import ScrapingKit

class ScrapingImageTests: XCTestCase {
    
    private let scraper = Scraper<ImageParser>()
    private let urlWithoutGif = URL.init(string: "http://vipsister23.com/archives/8701065.html")!
    private let urlWithGif = URL.init(string: "http://vipsister23.com/archives/8701324.html")!
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testScraping() {
        scraper.setConfiguration(.init(fetchSize: false, exclusions: []))
        
        let expectation = self.expectation(description: "scraping")
        let start = Date()
        
        scraper.scrape(urlWithGif) { (result) in
            defer { expectation.fulfill() }
            let span = start.timeIntervalSince(Date())
            print("経過時間(サイズ取得なし) = \(span)")
            
            result.forEach{ print("[DEBUG]: \($0.imageUrlString)") }
        }
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testScrapingWithFetchSize() {
        scraper.setConfiguration(.init(fetchSize: true, exclusions: []))
        
        let expectation = self.expectation(description: "scraping")
        let start = Date()
        
        scraper.scrape(urlWithGif) { (result) in
            defer { expectation.fulfill() }
            let span = start.timeIntervalSince(Date())
            print("経過時間(サイズ取得あり) = \(span)")
            
            result.forEach{ print("[DEBUG]: \($0.imageUrlString)") }
        }
        
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
}
