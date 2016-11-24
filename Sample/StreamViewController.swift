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

    enum Section {
        case item
        case loading
        
        static var allSection: [Section] {
            return [.item, .loading]
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    fileprivate var items: [Document.Item] = [] {
        didSet {
            reloadTable()
        }
    }
    
    private let hitCount = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        constructRefreshControl()
    }
    
    fileprivate func add() {
        if items.count == 0 {
            fetch()
        } else {
            let additionalItems = DocumentRepository.shared.get(from: items.count, to: items.count + hitCount)
            if additionalItems.count > 0 {
                items += additionalItems
            }
        }
    }
    
    private func fetch() {
        DocumentRepository.shared.recent(to: hitCount) { [weak self] (items) in
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
        switch indexPath.section {
        case Section.item.hashValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "StreamTableViewCell") as! StreamTableViewCell
            cell.configure(item: items[indexPath.row])
            return cell
        case Section.loading.hashValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "StreamLoadingTableViewCell") as! StreamLoadingTableViewCell
            cell.animateIndicator()
            add()
            return cell
        default: return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case Section.item.hashValue: return items.count
        case Section.loading.hashValue: return 1
        default: return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allSection.count
    }
}

extension StreamViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case Section.item.hashValue:
            let item = items[indexPath.row]
            let safariVC = SFSafariViewController.init(url: item.link)
            present(safariVC, animated: true, completion: nil)
        case Section.loading.hashValue: break
        default: break
        }
    }
}
