//
//  ReaderKitTests.swift
//  ReaderKitTests
//
//  Created by chocoyama on 2016/10/27.
//  Copyright © 2016年 chocoyama. All rights reserved.
//

import XCTest
@testable import ReaderKit

struct ReaderKitTestsResources {
    static let atomSiteUrl = URL(string: "http://himaratsu.hatenablog.com/")!
    
    static let rss1_0url = URL(string: "https://www.nttdocomo.co.jp/info/rss/whatsnew.rdf")!
    static let rss2_0url = URL(string: "http://himaratsu.hatenablog.com/rss")!
    static let atomurl = URL(string: "http://himaratsu.hatenablog.com/feed")!
    static var rss1_0data: Data { return try! Data.init(contentsOf: rss1_0url) }
    static var rss2_0data: Data { return try! Data.init(contentsOf: rss2_0url) }
    static var atomdata: Data { return try! Data.init(contentsOf: atomurl) }
    
    static var contentsPage = URL(string: "http://vipsister23.com/archives/8629268.html")!
}

class ReaderKitTests: XCTestCase {
    
    private let reader = Reader.init()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testReader() {
        let expectation: XCTestExpectation? = self.expectation(description: "fetch")
        let url = ReaderKitTestsResources.atomSiteUrl
        reader.read(url) { (document, error) in
            if let document = document {
                XCTAssertTrue(document.documentItems.count > 0)
            } else {
                XCTFail()
            }
            expectation?.fulfill()
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
