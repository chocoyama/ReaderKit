//
//  ViewController.swift
//  Sample
//
//  Created by chocoyama on 2016/10/30.
//  Copyright © 2016年 chocoyama. All rights reserved.
//

import UIKit
import ReaderKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    private let reader = Reader.init()
    private var choices = [Choice]() {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK:- TableView
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchChoiceTableViewCell", for: indexPath) as! SearchChoiceTableViewCell
        cell.configure(with: choices[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return choices.count
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
        
        choices = reader.choices(from: url)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.characters.count == 0 {
            choices = []
        }
    }
    
    // Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let documentVC = segue.destination as? DocumentViewController,
            let indexPath = tableView.indexPathForSelectedRow {
            let choice = choices[indexPath.row]
            documentVC.choice = choice
        }
    }
}

