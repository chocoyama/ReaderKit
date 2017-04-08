//
//  DocumentTests.swift
//  ReaderKit
//
//  Created by takyokoy on 2016/11/23.
//  Copyright © 2016年 chocoyama. All rights reserved.
//
import XCTest
@testable import ReaderKit
import Realm
import RealmSwift

class DocumentTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        let _ = DocumentRepository.shared.unsubscriveAll()
        super.tearDown()
    }
    
    func testSummary() {
        let thinkBigActLocal = ReaderKitTestsResources.thinkBigActLocal
        let result = DocumentRepository.shared.subscribe(thinkBigActLocal)
        if result != nil {
            XCTFail()
        }
        
        let document = DocumentRepository.shared.get(thinkBigActLocal.link)!
        let summary = document.summary
        
        XCTAssertEqual(summary.title, "Think Big Act Local")
        XCTAssertEqual(summary.link, URL.init(string: "http://himaratsu.hatenablog.com/feed"))
        XCTAssertEqual(summary.itemCount, 5)
        XCTAssertEqual(summary.unreadCount, 5)
        XCTAssertEqual(summary.lastUpdated, "2016-08-23T02:16:21+09:00".toDate(format: ATOM.dateFormat))
    }
    
    func testReadFlag() {
        let thinkBigActLocal = ReaderKitTestsResources.thinkBigActLocal
        let result = DocumentRepository.shared.subscribe(thinkBigActLocal)
        if result != nil {
            XCTFail()
        }
        
        let document = DocumentRepository.shared.get(thinkBigActLocal.link)!
        let item = document.items.first!

        let _ = DocumentRepository.shared.read(item, read: true)
        
        let summary = document.summary
        XCTAssertEqual(summary.title, "Think Big Act Local")
        XCTAssertEqual(summary.link, URL.init(string: "http://himaratsu.hatenablog.com/feed"))
        XCTAssertEqual(summary.itemCount, 5)
        XCTAssertEqual(summary.unreadCount, 4)
        XCTAssertEqual(summary.lastUpdated, "2016-08-23T02:16:21+09:00".toDate(format: ATOM.dateFormat))
    }
    
}
