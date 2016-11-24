//
//  ReaderKitRealmTests.swift
//  ReaderKit
//
//  Created by chocoyama on 2016/10/30.
//  Copyright © 2016年 chocoyama. All rights reserved.
//

import XCTest
@testable import ReaderKit

class ReaderKitRealmTests: XCTestCase {
    
    private let reader = Reader.init()
    
    override func setUp() {
        super.setUp()
        deleteAll()
    }
    
    override func tearDown() {
        deleteAll()
        super.tearDown()
    }
    
    private func deleteAll() {
        do {
            try DocumentRepository.shared.unsubscriveAll()
        } catch let error {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testRecent() {
        let link = ReaderKitTestsResources.rss1_0url
        let expectation: XCTestExpectation? = self.expectation(description: "fetch")
        DocumentRepository.shared.recent(link) { (document) in
            defer { expectation?.fulfill() }
            
            if let document = document {
                XCTAssertTrue(document.link == link)
            } else {
                XCTFail()
            }
        }
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func testGetItems() {
        let thinkBigActLocal = ReaderKitTestsResources.thinkBigActLocal
        let vipSister = ReaderKitTestsResources.vipSister
        
        try! thinkBigActLocal.subscribe()
        try! vipSister.subscribe()
        
        let items = DocumentRepository.shared.get(from: 0, to: 1)
        XCTAssertTrue(items.count == 1)
        XCTAssertTrue(items[0].date == vipSister.items.first?.date)
        
        let totalItemCount = thinkBigActLocal.items.count + vipSister.items.count
        let maxItems = DocumentRepository.shared.get(from: 0, to: totalItemCount)
        XCTAssertTrue(maxItems.count == totalItemCount)
        
        let overMaxItems = DocumentRepository.shared.get(from: 0, to: totalItemCount * 2)
        XCTAssertTrue(overMaxItems.count == totalItemCount)
    }
    
    func testRecentItems() {
        let thinkBigActLocal = ReaderKitTestsResources.thinkBigActLocal
        let vipSister = ReaderKitTestsResources.vipSister
        
        try! thinkBigActLocal.subscribe()
        try! vipSister.subscribe()
        
        let expectation = self.expectation(description: "fetch")
        DocumentRepository.shared.recent(to: 20) { (items) in
            defer { expectation.fulfill() }
            
            XCTAssertTrue(items.count == 20)
        }
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
}
