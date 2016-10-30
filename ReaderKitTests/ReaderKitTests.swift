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
        let expectation: XCTestExpectation? = self.expectation(description: "fetch")
        let url = ReaderKitTestsResources.atomSiteUrl
        reader.read(url) { (document, error) in
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
