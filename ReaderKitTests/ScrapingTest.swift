//
//  ScrapingTest.swift
//  ReaderKit
//
//  Created by takyokoy on 2017/01/06.
//  Copyright © 2017年 chocoyama. All rights reserved.
//

import XCTest
@testable import ReaderKit

class ScrapingTest: XCTestCase {
    
    private var scraper: Scraper?
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testScraping() {
        let expectation = self.expectation(description: "scraping")
        
        let url = ReaderKitTestsResources.thinkBigActLocal.items.first?.link
        scraper = Scraper.init(with: url!)
        scraper?.getImages(fetchSize: true, completion: { (images) in
            defer { expectation.fulfill() }
            
            images.forEach {
                XCTAssertNotNil($0.imageSize, "\($0.imageUrlString) のサイズ取得に失敗")
            }
        })
        
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
}
