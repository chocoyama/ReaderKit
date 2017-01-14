//
//  ResultViewController.swift
//  ScrapingKit
//
//  Created by takyokoy on 2017/01/08.
//  Copyright © 2017年 chocoyama. All rights reserved.
//

import UIKit
import ScrapingKit
import SafariServices

class ResultViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var results: ImageParser.Result?
    var scrapeTime: TimeInterval?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        
        if let scrapeTime = scrapeTime {
            title = "\(scrapeTime)秒かかりました"
        }
    }
}

extension ResultViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let results = results else { return UITableViewCell() }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath) as! ResultTableViewCell
        
        let size = results[indexPath.row].imageSize
        let title = "URL: \(results[indexPath.row].imageUrlString)\nwidth: \(size?.width ?? 0)\nheight: \(size?.height ?? 0)"
        
        cell.configure(title: title)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results?.count ?? 0
    }
}

extension ResultViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let results = results,
            let imageUrl = results[indexPath.row].imageUrl else { return }
        let vc = SFSafariViewController.init(url: imageUrl)
        navigationController?.pushViewController(vc, animated: true)
    }
}
