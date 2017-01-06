//
//  DocumentRepository.swift
//  ReaderKit
//
//  Created by chocoyama on 2016/10/29.
//  Copyright © 2016年 chocoyama. All rights reserved.
//

import Foundation

open class DocumentRepository {
    private init() {}
    open static let shared = DocumentRepository()
    fileprivate let documentProvider = DocumentProvider.init()
    
    open func recent(_ link: URL, completion: @escaping (Document?) -> Void) {
        fetch(link) { [weak self] (result) in
            guard result == true else {
                completion(nil)
                return
            }
            
            let document = self?.get(link)
            completion(document)
        }
    }
    
    open func recent(to: Int, completion: @escaping (_ items: [DocumentItem]) -> Void) {
        fetchAll { [weak self] in
            let items = self?.get(from: 0, to: to) ?? []
            completion(items)
        }
    }
    
    open func get(_ link: URL) -> Document? {
        guard let realmDocument = RealmManager.getRealmDocument(from: link) else { return nil }
        var documentItems: [DocumentItem] = []
        realmDocument.items
            .flatMap{ $0.toDocumentItem() }
            .forEach{ documentItems.append($0) }
        return Document(title: realmDocument.title, link: link, items: documentItems)
    }
    
    open func get(from: Int, to: Int) -> [DocumentItem] {
        let realmDocumentItems = RealmManager.getRealmDocumentItems(from: from, to: to)
        var documentItems: [DocumentItem] = []
        realmDocumentItems
            .flatMap{ $0.toDocumentItem() }
            .forEach{ documentItems.append($0) }
        return documentItems
    }
    
    open var subscribedDocumentSummaries: [Document.Summary] {
        guard let result = RealmManager.getRealmDocumentResult() else { return [] }
        
        var summaries = Array<Document.Summary>()
        result.forEach {
            if let summary = $0.toDocumentSummary() {
                summaries.append(summary)
            }
        }
        return summaries
    }
    
    open func unsubscriveAll() -> Bool {
        return RealmManager.deleteAll()
    }
    
}

extension DocumentRepository {
    internal func fetch(_ link: URL, completion: @escaping (_ result: Bool) -> Void) {
        documentProvider.get(from: link, handler: { [weak self] (document, error) in
            guard let document = document else {
                completion(false)
                return
            }
            
            DispatchQueue.main.async {
                let result = self?.update(document) ?? false
                completion(result)
            }
        })
    }
    
    internal func fetchAll(completion: @escaping () -> Void) {
        let summaries = subscribedDocumentSummaries
        
        let group = DispatchGroup()
        summaries.forEach {
            group.enter()
            fetch($0.link) { _ in group.leave() }
        }
        
        group.notify(queue: .main) {
            completion()
        }
    }
    
    internal func update(_ document: Document) -> Bool {
        guard let realmDocument = RealmManager.getRealmDocument(from: document.link),
            let realm = RealmManager.makeRealm() else {
                return RealmManager.subscribe(document: document)
        }
        
        let newItems = document.realmItems.filter { !realmDocument.itemIds.contains($0.id) }
        return RealmManager.write(realm: realm) {
            realmDocument.items.append(objectsIn: newItems)
        }
    }
    
}
