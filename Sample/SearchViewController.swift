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

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var rightBarButton: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!

    private let reader = Reader.init()
    private var document: Document? {
        didSet {
            if let document = document {
                navItem.title = document.title
                rightBarButton.title = document.subscribed ? "購読解除" : "購読する"
            } else {
                navItem.title = "検索"
                rightBarButton.title = ""
            }
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK:- TableView
    
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
    
    // MARK:- SearchBar
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let inputText = searchBar.text, let url = URL(string: inputText) else {
            return
        }
        
        reader.read(url) { [weak self] (document, error) in
            DispatchQueue.main.async {
                self?.document = document
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.characters.count == 0 {
            document = nil
        }
    }
    
    // MARK:- NavigationItem
    
    @IBAction func didTappedRightBarButton(_ sender: UIBarButtonItem) {
        guard let document = document else {
            rightBarButton.title = ""
            return
        }
        
        defer {
            self.document = document
        }
        
        if document.subscribed {
            try? document.unSubscribe()
        } else {
            try? document.subscribe()
        }
    }
}

