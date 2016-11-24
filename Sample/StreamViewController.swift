//
//  StreamViewController.swift
//  ReaderKit
//
//  Created by takyokoy on 2016/11/24.
//  Copyright © 2016年 chocoyama. All rights reserved.
//

import UIKit
import ReaderKit
import SafariServices

class StreamViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    fileprivate var items: [Document.Item] = [] {
        didSet { reloadTable() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        constructRefreshControl()
        fetch()
    }
    
    private func fetch() {
        DocumentRepository.shared.recent(to: 20) { [weak self] (items) in
            self?.items = items
        }
    }
    
    private func constructRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(StreamViewController.refresh), for: UIControlEvents.valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    func refresh() {
        tableView.refreshControl?.beginRefreshing()
        fetch()
        tableView.refreshControl?.endRefreshing()
    }
    
    private func reloadTable() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

extension StreamViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StreamTableViewCell") as! StreamTableViewCell
        cell.configure(item: items[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
}

extension StreamViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        let safariVC = SFSafariViewController.init(url: item.link)
        present(safariVC, animated: true, completion: nil)
    }
}
