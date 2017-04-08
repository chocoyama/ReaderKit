//
//  FetchTests.swift
//  ReaderKit
//
//  Created by chocoyama on 2016/11/01.
//  Copyright © 2016年 chocoyama. All rights reserved.
//
import XCTest
@testable import ReaderKit
import Realm
import RealmSwift

class FetchTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        deleteAll()
        super.tearDown()
    }
    
    private func deleteAll() {
        let result = DocumentRepository.shared.unsubscriveAll()
        if result != nil {
            XCTFail()
        }
    }
    
    func testFetch() {
        let link = ReaderKitTestsResources.rss1_0url
        let expectation: XCTestExpectation? = self.expectation(description: "fetch")
        DocumentRepository.shared.fetch(link) { (result) in
            defer { expectation?.fulfill() }
            if result != nil {
                XCTFail()
            }
            
            let document  = DocumentRepository.shared.get(link.absoluteString)
            XCTAssertTrue(document?.link == link.absoluteString)
        }
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func testFetchAll() {
        let thinkBigActLocal = ReaderKitTestsResources.thinkBigActLocal
        let oldThinkBigActLocalCount = thinkBigActLocal.items.count
        let vipSister = ReaderKitTestsResources.vipSister
        let oldVipSisterCount = vipSister.items.count
        
        let result1 = DocumentRepository.shared.subscribe(thinkBigActLocal)
        let result2 = DocumentRepository.shared.subscribe(vipSister)
        if result1 != nil || result2 != nil {
            XCTFail()
        }
        
        let expectation = self.expectation(description: "fetch")
        
        DocumentRepository.shared.fetchAll {
            defer {
                expectation.fulfill()
            }
            
            let updatedThinkBigActLocal = DocumentRepository.shared.get(thinkBigActLocal.link)
            let updatedVipSister = DocumentRepository.shared.get(vipSister.link)
            XCTAssertTrue(updatedThinkBigActLocal?.items.count ?? 0 > oldThinkBigActLocalCount)
            XCTAssertTrue(updatedVipSister?.items.count ?? 0 > oldVipSisterCount)
        }
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func testUpdate() {
        let documentTitle = "test"
        let documentLink = URL(string: "http://www.yahoo.co.jp/")!
        
        let itemCount = 100
        let itemUrls = (0..<itemCount).map { URL(string: "http://www.yahoo.co.jp/\($0)")! }
        let items = (0..<itemCount).map { (offset) -> DocumentItem in
            let item = DocumentItem()
            item.documentTitle = documentTitle
            item.documentLink = documentLink.absoluteString
            item.title = "test"
            item.link = itemUrls[offset].absoluteString
            item.desc = "test"
            item.date = Date()
            item.read = false
            return item
        }
        
        let document = Document()
        document.title = "test"
        document.link = documentLink.absoluteString
        document.items.append(objectsIn: items)
        let result1 = DocumentRepository.shared.update(document)
        if result1 != nil {
            XCTFail()
        }
        let gotDocument = DocumentRepository.shared.get(documentLink.absoluteString)
        XCTAssertTrue(gotDocument?.items.count == itemCount)
        
        var newItems = items.enumerated().filter{ $0.offset < 10 }.map{ $0.element }
        let newlink = URL(string: "http://www.yahoo.co.jp/new")!
        let item = DocumentItem()
        item.documentTitle = gotDocument!.title
        item.documentLink = gotDocument!.link
        item.title = "test"
        item.link = newlink.absoluteString
        item.desc = "test"
        item.date = Date()
        item.read = false
        newItems.append(item)
        
        let document2 = Document()
        document2.title = "test"
        document2.link = documentLink.absoluteString
        document2.items.append(objectsIn: newItems)
        let result2 = DocumentRepository.shared.update(document2)
        if result2 != nil {
            XCTFail()
        }
        let newGotDocument = DocumentRepository.shared.get(documentLink.absoluteString)
        XCTAssertTrue(newGotDocument?.items.count == itemCount + 1)
    }
    
}
