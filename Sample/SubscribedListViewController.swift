//
//  SubscribedListViewController.swift
//  ReaderKit
//
//  Created by takyokoy on 2016/10/31.
//  Copyright © 2016年 chocoyama. All rights reserved.
//

import UIKit
import ReaderKit
import SafariServices

class SubscribedListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    private var documents = [Document]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        documents = DocumentRepository.shared.subscribedDocuments
    }
    
    // MARK:- TableView
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubscribedListTableViewCell") as! SubscribedListTableViewCell
        cell.configure(with: documents[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return documents.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let safariVC = SFSafariViewController.init(url: documents[indexPath.row].link)
        present(safariVC, animated: true, completion: nil)
    }

}
