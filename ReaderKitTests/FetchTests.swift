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
        do {
            try DocumentRepository.shared.unsubscriveAll()
        } catch let error {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testFetch() {
        let link = ReaderKitTestsResources.rss1_0url
        let expectation: XCTestExpectation? = self.expectation(description: "fetch")
        DocumentRepository.shared.fetch(link) { (error) in
            defer { expectation?.fulfill() }
            if let _ = error {
                XCTFail()
            }
            
            let document  = DocumentRepository.shared.get(link)
            XCTAssertTrue(document?.link == link)
        }
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func testFetchAll() {
        try! ReaderKitTestsResources.thinkBigActLocal.subscribe()
        try! ReaderKitTestsResources.vipSister.subscribe()
        
        let expectation = self.expectation(description: "fetch")
        DocumentRepository.shared.fetchAll {
            defer {
                expectation.fulfill()
            }
            
            let documents = DocumentRepository.shared.subscribedDocuments
            let updatedThinkBigActLocal = documents.filter{ $0.id == ReaderKitTestsResources.thinkBigActLocal.id }.first
            let updatedVipSister = documents.filter{ $0.id == ReaderKitTestsResources.vipSister.id }.first
            XCTAssertTrue(updatedThinkBigActLocal?.items.count ?? 0 > ReaderKitTestsResources.thinkBigActLocal.items.count)
            XCTAssertTrue(updatedVipSister?.items.count ?? 0 > ReaderKitTestsResources.vipSister.items.count)
        }
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func testUpdate() {
        let documentTitle = "test"
        let documentLink = URL(string: "http://www.yahoo.co.jp/")!
        
        let itemCount = 100
        let itemUrls = (0..<itemCount).map { URL(string: "http://www.yahoo.co.jp/\($0)")! }
        let items = (0..<itemCount).map {
            Document.Item.init(
                documentTitle: documentTitle,
                documentLink: documentLink,
                title: "test",
                link: itemUrls[$0],
                desc: "test",
                date: Date.init(),
                read: false
            )
        }
        
        let newDocument = Document.init(title: "test", link: documentLink, items: items)
        
        do {
            try DocumentRepository.shared.update(newDocument)
            let gotDocument = DocumentRepository.shared.get(documentLink)
            XCTAssertTrue(gotDocument?.items.count == itemCount)
            
            var newItems = items.enumerated().filter{ $0.offset < 10 }.map{ $0.element }
            let newlink = URL(string: "http://www.yahoo.co.jp/new")!
            newItems.append(
                Document.Item.init(
                    documentTitle: gotDocument!.title,
                    documentLink: gotDocument!.link,
                    title: "test",
                    link: newlink,
                    desc: "test",
                    date: Date.init(),
                    read: false
                )
            )
            let newDocument = Document.init(title: "test", link: documentLink, items: newItems)
            try DocumentRepository.shared.update(newDocument)
            let newGotDocument = DocumentRepository.shared.get(documentLink)
            XCTAssertTrue(newGotDocument?.items.count == itemCount + 1)
        } catch let error {
            XCTFail(error.localizedDescription)
        }
    }
    
}
