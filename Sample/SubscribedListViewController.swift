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

class SubscribedListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    fileprivate var summaries = Array<Document.Summary>() {
        didSet { reloadTable() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        summaries = DocumentRepository.shared.subscribedDocumentSummaries
    }
    
    fileprivate func refresh() {
        summaries = DocumentRepository.shared.subscribedDocumentSummaries
    }
    
    private func reloadTable() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }

}

extension SubscribedListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubscribedListTableViewCell") as! SubscribedListTableViewCell
        cell.delegate = self
        cell.configure(with: summaries[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return summaries.count
    }
}

extension SubscribedListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let safariVC = SFSafariViewController.init(url: summaries[indexPath.row].link)
        present(safariVC, animated: true, completion: nil)
    }
}

extension SubscribedListViewController: SubscribedListTableViewCellDelegate {
    func didUnsubscribed(document: Document) {
        refresh()
    }
}
