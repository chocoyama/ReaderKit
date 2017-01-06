//
//  FetchTests.swift
//  ReaderKit
//
//  Created by chocoyama on 2016/11/01.
//  Copyright © 2016年 chocoyama. All rights reserved.
//

import XCTest
@testable import ReaderKit

class FetchTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        deleteAll()
    }
    
    override func tearDown() {
        deleteAll()
        super.tearDown()
    }
    
    private func deleteAll() {
        let result = RealmManager.deleteAll()
        if result == false {
            XCTFail()
        }
    }
    
    func testFetch() {
        let link = ReaderKitTestsResources.rss1_0url
        let expectation: XCTestExpectation? = self.expectation(description: "fetch")
        DocumentRepository.shared.fetch(link) { (result) in
            defer { expectation?.fulfill() }
            if result == false {
                XCTFail()
            }
            
            let document  = DocumentRepository.shared.get(link)
            XCTAssertTrue(document?.link == link)
        }
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func testFetchAll() {
        let thinkBigActLocal = ReaderKitTestsResources.thinkBigActLocal
        let vipSister = ReaderKitTestsResources.vipSister
        
        let result1 = thinkBigActLocal.subscribe()
        let result2 = vipSister.subscribe()
        if result1 == false || result2 == false {
            XCTFail()
        }
        
        let expectation = self.expectation(description: "fetch")
        
        DocumentRepository.shared.fetchAll {
            defer {
                expectation.fulfill()
            }
            
            let updatedThinkBigActLocal = DocumentRepository.shared.get(thinkBigActLocal.link)
            let updatedVipSister = DocumentRepository.shared.get(vipSister.link)
            XCTAssertTrue(updatedThinkBigActLocal?.items.count ?? 0 > thinkBigActLocal.items.count)
            XCTAssertTrue(updatedVipSister?.items.count ?? 0 > vipSister.items.count)
        }
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func testUpdate() {
        let documentTitle = "test"
        let documentLink = URL(string: "http://www.yahoo.co.jp/")!
        
        let itemCount = 100
        let itemUrls = (0..<itemCount).map { URL(string: "http://www.yahoo.co.jp/\($0)")! }
        let items = (0..<itemCount).map {
            DocumentItem.init(
                documentTitle: documentTitle,
                documentLink: documentLink,
                title: "test",
                link: itemUrls[$0],
                desc: "test",
                date: Date.init(),
                read: false
            )
        }
        
        let result1 = DocumentRepository.shared.update(.init(title: "test", link: documentLink, items: items))
        if result1 == false {
            XCTFail()
        }
        let gotDocument = DocumentRepository.shared.get(documentLink)
        XCTAssertTrue(gotDocument?.items.count == itemCount)
        
        var newItems = items.enumerated().filter{ $0.offset < 10 }.map{ $0.element }
        let newlink = URL(string: "http://www.yahoo.co.jp/new")!
        newItems.append(
            DocumentItem.init(
                documentTitle: gotDocument!.title,
                documentLink: gotDocument!.link,
                title: "test",
                link: newlink,
                desc: "test",
                date: Date.init(),
                read: false
            )
        )
        
        let result2 = DocumentRepository.shared.update(.init(title: "test", link: documentLink, items: newItems))
        if result2 == false {
            XCTFail()
        }
        let newGotDocument = DocumentRepository.shared.get(documentLink)
        XCTAssertTrue(newGotDocument?.items.count == itemCount + 1)
    }
    
}
