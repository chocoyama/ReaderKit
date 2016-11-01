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
    
    func testDeleteAll() {
        do {
            try DocumentRepository.shared.unsubscriveAll()
        } catch let error {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testSubscribe() {
        let expectation: XCTestExpectation? = self.expectation(description: "fetch")
        let url = ReaderKitTestsResources.atomSiteUrl
        reader.read(url) { (document, error) in
            defer { expectation?.fulfill() }
            guard let document = document else {
                XCTFail()
                return
            }
            
            do {
                try document.subscribe()
            } catch let error {
                XCTFail(error.localizedDescription)
            }
        }
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func testUnsubscribe() {
        let expectation: XCTestExpectation? = self.expectation(description: "fetch")
        let url = ReaderKitTestsResources.atomSiteUrl
        reader.read(url) { (document, error) in
            defer { expectation?.fulfill() }
            guard let document = document else {
                XCTFail()
                return
            }
            
            // 購読してないものを削除
            do {
                try document.unSubscribe()
            } catch let error {
                XCTFail(error.localizedDescription)
            }
            
            // 購読
            do {
                try document.subscribe()
            } catch let error {
                XCTFail(error.localizedDescription)
            }
            
            // 購読済みのものを削除
            do {
                try document.unSubscribe()
            } catch let error {
                XCTFail(error.localizedDescription)
            }
        }
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func testSubscribed() {
        let expectation: XCTestExpectation? = self.expectation(description: "fetch")
        let url = ReaderKitTestsResources.atomSiteUrl
        reader.read(url) { (document, error) in
            defer { expectation?.fulfill() }
            guard let document = document else {
                XCTFail()
                return
            }
            
            // 購読してない
            XCTAssertFalse(document.subscribed)
            
            // 購読
            do {
                try document.subscribe()
            } catch let error {
                XCTFail(error.localizedDescription)
            }
            XCTAssertTrue(document.subscribed)
            
            // 購読済みのものを削除
            do {
                try document.unSubscribe()
            } catch let error {
                XCTFail(error.localizedDescription)
            }
            XCTAssertFalse(document.subscribed)
        }
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func testAccessAllSubscribedDocument() {
        let documentsCount = 20
        let documentTitles = (0..<documentsCount).map{ "test\($0)" }
        let documentUrls = (0..<documentsCount).map{ URL(string: "http://google.com/\($0)")! }
        
        let itemCount = 100
        let urls = (0..<itemCount).map { URL(string: "http://www.yahoo.co.jp/\($0)")! }
        
        var documents = [Document]()
        for offset in (0..<documentsCount) {
            let documentTitle = documentTitles[offset]
            let documentUrl = documentUrls[offset]
            let items = (0..<itemCount).map {
                Document.Item.init(
                    documentTitle: documentTitle,
                    documentLink: documentUrl,
                    title: "test",
                    link: urls[$0],
                    desc: "test",
                    date: Date.init(),
                    read: false
                )
            }
            let document = Document.init(
                title: documentTitle,
                link: documentUrl,
                items: items
            )
            documents.append(document)
        }
        
        documents.forEach {
            do {
                try $0.subscribe()
            } catch let error {
                XCTFail(error.localizedDescription)
            }
        }
        
        self.measure {
            let subscribedCount = DocumentRepository.shared.subscribedDocuments.count
            XCTAssertTrue(subscribedCount == documentsCount)
        }
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
    
    func testFetch() {
        let link = ReaderKitTestsResources.rss1_0url
        let expectation: XCTestExpectation? = self.expectation(description: "fetch")
        DocumentRepository.shared.fetch(link)
        { (error) in
            defer { expectation?.fulfill() }
            if let _ = error {
                XCTFail()
            }
            
            let document  = DocumentRepository.shared.get(link)
            XCTAssertTrue(document?.link == link)
        }
        waitForExpectations(timeout: 2.0, handler: nil)
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
        waitForExpectations(timeout: 3.0, handler: nil)
    }
    
}
