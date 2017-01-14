//
//  ViewController.swift
//  Sample
//
//  Created by takyokoy on 2017/01/08.
//  Copyright © 2017年 chocoyama. All rights reserved.
//

import UIKit
import ScrapingKit

class ViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    private let scraper: Scraper<ImageParser> = {
        let scraper = Scraper<ImageParser>()
        scraper.setConfiguration(.init(fetchSize: true, exclusions: []))
        return scraper
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func didTappedScrapeImageButton(_ sender: Any) {
        scrape { [weak self] in
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ResultViewController") as! ResultViewController
            vc.results = $0.0
            vc.scrapeTime = $0.1
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func scrape(_ completion: @escaping (ImageParser.Result, TimeInterval) -> Void) {
        guard let text = textField.text,
            let url = URL.init(string: text) else { return }
        let start = Date()
        scraper.scrape(url) { (result) in
            let scrapeTime = start.timeIntervalSince(Date())
            DispatchQueue.main.async {
                completion(result, scrapeTime)
            }
        }
    }
}

