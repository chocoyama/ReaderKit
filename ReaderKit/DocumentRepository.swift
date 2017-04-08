//
//  DocumentRepository.swift
//  ReaderKit
//
//  Created by chocoyama on 2016/10/29.
//  Copyright © 2016年 chocoyama. All rights reserved.
//

import Foundation
import RealmSwift

open class DocumentRepository {
    private init() {}
    open static let shared = DocumentRepository()
    fileprivate let documentProvider = DocumentProvider.init()
    
    open func recent(_ link: URL, completion: @escaping (Document?) -> Void) {
        fetch(link) { [weak self] (result) in
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
    open func subscribe(_ link: String, completion: @escaping (Bool) -> Void) {
        let reader = Reader()
        guard let url = URL(string: link), let feedUrl = reader.choices(from: url).first?.url else {
            completion(false);
            return
        }
        
        reader.read(feedUrl) { (document, error) in
            guard let document = document, error == nil else { completion(false); return }
            let result = DocumentRepository.shared.subscribe(document)
            completion(result)
        }
    }
    
    open func subscribe(_ document: Document) -> Bool {
        guard let realm = RealmHelper.create() else { return false }
        return RealmHelper.write(realm) {
            realm.add(document, update: true)
        }
    }
    
    open func unsubscribe(_ link: String) -> Bool {
        guard let document = get(link) else { return false }
        return unsubscribe(document)
    }
    
    open func unsubscribe(_ document: Document) -> Bool {
        guard let realm = RealmHelper.create() else { return false }
        let isSucceeded = RealmHelper.write(realm) {
            realm.delete(document.items)
        }
        
        if isSucceeded == false {
            return false
        }
        
        return RealmHelper.write(realm) {
            realm.delete(document)
        }
    }
    
    open func unsubscriveAll() -> Bool {
        return RealmHelper.deleteAll()
    }
    
    open func read(_ documentItem: DocumentItem, read: Bool) -> Bool {
        return RealmHelper.write {
            documentItem.read = read
        }
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
    internal func fetch(_ link: URL, completion: @escaping (_ result: Bool) -> Void) {
        documentProvider.get(from: link) { [weak self] (document, error) in
            guard let document = document else {
                completion(false)
                return
            }
            
            DispatchQueue.main.async {
                let result = self?.update(document) ?? false
                completion(result)
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
    
    internal func update(_ document: Document) -> Bool {
        let isSubscribed = checkSubscribed(link: document.link)
        if isSubscribed {
            guard let storedDocument = get(document.link) else { return false }
            let newItems = document.items.filter{ !storedDocument.itemLinks.contains($0.link) }
            return RealmHelper.write {
                storedDocument.items.append(objectsIn: newItems)
            }
        } else {
            return subscribe(document)
        }
    }
    
}
