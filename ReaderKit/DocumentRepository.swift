//
//  DocumentRepository.swift
//  ReaderKit
//
//  Created by chocoyama on 2016/10/29.
//  Copyright © 2016年 chocoyama. All rights reserved.
//

import Foundation
import RealmSwift

public enum ReaderKitError: Error {
    case cannotExtractFeedUrl
    case cannotGetDocument
    case noDocumentItem
    case updateDocumentFailed
    case deleteItemFailed
    case deleteDocumentFailed
    case subscribeFailed
    case unsubscribeFailed
    case changeReadFlagFailed
    case realmError
}

open class DocumentRepository {
    private init() {}
    open static let shared = DocumentRepository()
    fileprivate let documentProvider = DocumentProvider.init()
    fileprivate let reader = Reader()
    
    open func recent(_ link: URL, completion: @escaping (Document?) -> Void) {
        fetch(link) { [weak self] (error) in
            let document = self?.get(link.absoluteString)
            completion(document)
        }
    }
    
    open func recent(to: Int, completion: @escaping (_ items: [DocumentItem]) -> Void) {
        fetchAll { [weak self] in
            let items = self?.get(from: 0, to: to) ?? []
            completion(items)
        }
    }
    
    open func get(_ link: String) -> Document? {
        return RealmHelper.create()?.object(ofType: Document.self, forPrimaryKey: link)
    }
    
    open func get(from: Int, to: Int) -> [DocumentItem] {
        guard let results = RealmHelper
                                .create()?
                                .objects(DocumentItem.self)
                                .sorted(byKeyPath: "date", ascending: false),
            from <= min(results.count, to) else { return [] }
        return (from..<min(results.count, to)).map{ results[$0] }
    }
    
    open func checkSubscribed(link: String) -> Bool {
        return get(link) != nil
    }
    
    open var subscribedDocumentSummaries: [Document.Summary] {
        return RealmHelper.create()?.objects(Document.self).map{ $0.summary } ?? []
    }
    
    open var subscribedDocumentCount: Int {
        return RealmHelper.create()?.objects(Document.self).count ?? 0
    }
    
}

extension DocumentRepository {
    open func subscribe(_ link: String, completion: @escaping (ReaderKitError?) -> Void) {
        guard let url = URL(string: link), let feedUrl = reader.choices(from: url).first?.url else {
            completion(.cannotExtractFeedUrl);
            return
        }
        
        reader.read(feedUrl) { (document, error) in
            guard let document = document, error == nil else { completion(.cannotGetDocument); return }
            let error = DocumentRepository.shared.subscribe(document)
            completion(error)
        }
    }
    
    open func subscribe(_ document: Document) -> ReaderKitError? {
        guard let realm = RealmHelper.create() else { return .realmError }
        let success = RealmHelper.write(realm) {
            realm.add(document, update: true)
        }
        return success ? nil : .subscribeFailed
    }
    
    open func unsubscribe(_ link: String) -> ReaderKitError? {
        guard let document = get(link) else { return .cannotGetDocument }
        return unsubscribe(document)
    }
    
    open func unsubscribe(_ document: Document) -> ReaderKitError? {
        guard let realm = RealmHelper.create() else { return .realmError }
        let isSucceeded = RealmHelper.write(realm) {
            realm.delete(document.items)
        }
        
        if isSucceeded == false {
            return .deleteItemFailed
        }
        
        let success = RealmHelper.write(realm) {
            realm.delete(document)
        }
        return success ? nil : .deleteDocumentFailed
    }
    
    open func unsubscriveAll() -> ReaderKitError? {
        let success = RealmHelper.deleteAll()
        return success ? nil : .realmError
    }
    
    open func read(_ documentItem: DocumentItem, read: Bool) -> ReaderKitError? {
        let success = RealmHelper.write {
            documentItem.read = read
        }
        return success ? nil : .changeReadFlagFailed
    }
}

extension DocumentRepository {
    fileprivate var subscribedDocumentUrls: [URL] {
        return RealmHelper.create()?
                .objects(Document.self)
                .flatMap{ URL(string: $0.link) } ?? []
    }
}

extension DocumentRepository {
    internal func fetch(_ link: URL, completion: @escaping (_ error: ReaderKitError?) -> Void) {
        documentProvider.getNewArrival(from: link) { [weak self] (document, error) in
            guard let document = document else {
                completion(.cannotGetDocument)
                return
            }
            
            DispatchQueue.main.async {
                let error = self?.update(document)
                completion(error)
            }
        }
    }
    
    internal func fetchAll(completion: @escaping () -> Void) {
        guard subscribedDocumentCount > 0 else { completion(); return }
        
        let group = DispatchGroup()
        let queue = DispatchQueue.main
        
        subscribedDocumentUrls.forEach { (url) in
            group.enter()
            queue.async(group: group) { [weak self] in
                self?.fetch(url) { _ in group.leave() }
            }
        }
        
        group.notify(queue: queue) {
            completion()
        }
    }
    
    internal func update(_ document: Document) -> ReaderKitError? {
        guard document.items.count > 0 else { return .noDocumentItem }
        let isSubscribed = checkSubscribed(link: document.link)
        if isSubscribed {
            guard let storedDocument = get(document.link) else { return .cannotGetDocument }
            let itemLinks = storedDocument.itemLinks
            let newItems = document.items.filter{ !itemLinks.contains($0.link) }
            let success = RealmHelper.write {
                storedDocument.items.append(objectsIn: newItems)
            }
            return success ? nil : .updateDocumentFailed
        } else {
            return subscribe(document)
        }
    }
    
}
