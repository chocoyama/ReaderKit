//
//  SearchChoiceTableViewCell.swift
//  ReaderKit
//
//  Created by chocoyama on 2016/10/31.
//  Copyright © 2016年 chocoyama. All rights reserved.
//

import UIKit
import ReaderKit

class SearchChoiceTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var linkLabel: UILabel!
    @IBOutlet weak var subscribeButton: UIButton!

    private var reader = Reader.init()
    private var document: Document? {
        didSet {
            if document?.subscribed == true {
                subscribeButton.setTitle("購読解除", for: .normal)
            } else {
                subscribeButton.setTitle("購読する", for: .normal)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with choice: Choice) {
        titleLabel.text = choice.title
        linkLabel.text = choice.url.absoluteString
        if let savedDocument = DocumentRepository.shared.get(choice.url) {
            self.document = savedDocument
        } else {
            reader.read(choice.url, handler: { [weak self] (document, error) in
                self?.document = document
            })
        }
    }
    
    @IBAction func didTappedSubscribeButton(_ sender: UIButton) {
        guard let document = document else {
            return
        }
        
        if document.subscribed == true {
            do {
                try document.unSubscribe()
                subscribeButton.setTitle("購読する", for: .normal)
            } catch {}
        } else {
            do {
                try document.subscribe()
                subscribeButton.setTitle("購読解除", for: .normal)
            } catch {}
        }
    }

}
