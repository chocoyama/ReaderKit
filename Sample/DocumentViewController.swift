//
//  DocumentViewController.swift
//  ReaderKit
//
//  Created by chocoyama on 2016/10/31.
//  Copyright © 2016年 chocoyama. All rights reserved.
//

import UIKit
import ReaderKit
import SafariServices

class DocumentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var choice: Choice?
    
    private let reader = Reader.init()
    private var document: Document? {
        didSet {
            DispatchQueue.main.async { [weak self] in
                if let document = self?.document {
                    self?.navigationItem.title = document.title
                    self?.navigationItem.rightBarButtonItem?.title = document.subscribed ? "購読解除" : "購読する"
                } else {
                    self?.navigationItem.title = "検索"
                    self?.navigationItem.rightBarButtonItem?.title = ""
                }
                self?.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        constructRightBarButton()
        if let url = choice?.url {
            reader.read(url, handler: { (document, error) in
                self.document = document
            })
        }
    }
    
    // MARK:- UITableView
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchItemTableViewCell", for: indexPath) as! SearchItemTableViewCell
        
        guard let item = document?.items[indexPath.row] else {
            return cell
        }
        
        cell.configure(item: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return document?.items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = document?.items[indexPath.row] else {
            return
        }
        let safariVC = SFSafariViewController.init(url: item.link)
        present(safariVC, animated: true, completion: nil)
    }

    // MARK:- UIBarButtonItem
    
    private func constructRightBarButton() {
        let button = UIBarButtonItem.init(
            title: "",
            style: .plain,
            target: self,
            action: #selector(self.didTappedRightBarButton(_:))
        )
        navigationItem.rightBarButtonItem = button
    }
    
    func didTappedRightBarButton(_ sender: UIBarButtonItem) {
        guard let document = document else {
            navigationItem.rightBarButtonItem?.title = ""
            return
        }
        
        if document.subscribed {
            try? document.unSubscribe()
        } else {
            try? document.subscribe()
        }
        
        self.document = document
    }
    
}
