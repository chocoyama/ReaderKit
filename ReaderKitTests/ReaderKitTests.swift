//
//  ReaderKitTests.swift
//  ReaderKitTests
//
//  Created by chocoyama on 2016/10/27.
//  Copyright © 2016年 chocoyama. All rights reserved.
//

import XCTest
@testable import ReaderKit

class ReaderKitTests: XCTestCase {
    
    private let reader = Reader.init()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testReader() {
        let url = ReaderKitTestsResources.atomSiteUrl
        
        let choices = reader.choices(from: url)
        XCTAssertEqual(choices[0].url, URL(string: "http://himaratsu.hatenablog.com/feed")!)
        XCTAssertEqual(choices[0].title, "Atom")
        XCTAssertEqual(choices[1].url, URL(string: "http://himaratsu.hatenablog.com/rss")!)
        XCTAssertEqual(choices[1].title, "RSS2.0")
        
        let expectation: XCTestExpectation? = self.expectation(description: "fetch")
        reader.read(choices[0].url) { (document, error) in
            defer {
                expectation?.fulfill()
            }
            if let document = document {
                XCTAssertTrue(document.items.count > 0)
            } else {
                XCTFail()
            }
        }
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func testExtractFeedUrl() {
        let extractService = ExtractService()
        let extractedUrl = extractService.extractFeedUrl(from: ReaderKitTestsResources.rss1_0SiteData)!.absoluteString
        XCTAssertEqual(extractedUrl, "http://blog.illusion.jp/feed")
    }
    
    func testDetectService() {
        let detectService = DetectService.init()
        
        XCTAssertEqual(detectService.determineDocumentType(from: ReaderKitTestsResources.atomurl), DocumentType.atom)
        XCTAssertEqual(detectService.determineDocumentType(from: ReaderKitTestsResources.rss2_0url), DocumentType.rss2_0)
        XCTAssertEqual(detectService.determineDocumentType(from: ReaderKitTestsResources.rss1_0url), DocumentType.rss1_0)
        
        XCTAssertEqual(detectService.determineDocumentType(from: ReaderKitTestsResources.atomdata), DocumentType.atom)
        XCTAssertEqual(detectService.determineDocumentType(from: ReaderKitTestsResources.rss2_0data), DocumentType.rss2_0)
        XCTAssertEqual(detectService.determineDocumentType(from: ReaderKitTestsResources.rss1_0data), DocumentType.rss1_0)
    }
    
    func testParse() {
        let rss1_0 = DocumentType.rss1_0
        let rss2_0 = DocumentType.rss2_0
        let atom = DocumentType.atom
        
        let rss1_0Entity = rss1_0.parse(data: ReaderKitTestsResources.rss1_0data, url: ReaderKitTestsResources.rss1_0url)
        let rss2_0Entity = rss2_0.parse(data: ReaderKitTestsResources.rss2_0data, url: ReaderKitTestsResources.rss2_0url)
        let atomEntity = atom.parse(data: ReaderKitTestsResources.atomdata, url: ReaderKitTestsResources.atomurl)
        
        XCTAssertTrue(rss1_0Entity.documentItems.count > 0)
        XCTAssertTrue(rss2_0Entity.documentItems.count > 0)
        XCTAssertTrue(atomEntity.documentItems.count > 0)
    }
    
    func testScrapingPerformance() {
        self.measure {
            let scrapingService = ScrapingService.init(with: ReaderKitTestsResources.contentsPage)
            let _ = scrapingService.getImages()
        }
    }
    
}
