//
//  ViewController.swift
//  Sample
//
//  Created by chocoyama on 2016/10/30.
//  Copyright © 2016年 chocoyama. All rights reserved.
//

import UIKit
import ReaderKit
import SafariServices

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var rightBarButton: UIBarButtonItem!

    private let reader = Reader.init()
    private var document: Document? {
        didSet {
            if let document = document {
                navItem.title = document.title
                state = document.subscribed ? .unsubscribe : .subscribe
            } else {
                state = .non
            }
        }
    }
    
    private var state: RightBarButtonState = .non {
        didSet {
            let title: String
            switch state {
            case .subscribe: title = "購読する"
            case .unsubscribe: title = "購読解除"
            case .non: title = ""
            }
            rightBarButton.title = title
        }
    }
    enum RightBarButtonState {
        case subscribe
        case unsubscribe
        case non
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK:- TableView Delegate
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! ItemTableViewCell
        if let item = document?.items[indexPath.row] {
            cell.configure(item: item)
            return cell
        } else {
            return cell
        }
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
    
    // MARK:- SearchBar Delegate
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let inputText = searchBar.text,
            let url = URL(string: inputText) else {
            return
        }
        reader.read(url) { [weak self] (document, error) in
            DispatchQueue.main.async {
                self?.document = document
                self?.tableView.reloadData()
            }
        }
    }
    
    @IBAction func didTappedRightBarButton(_ sender: UIBarButtonItem) {
        switch state {
        case .subscribe: try! document?.subscribe()
        case .unsubscribe: try! document?.unSubscribe()
        case .non: break
        }
    }
}

