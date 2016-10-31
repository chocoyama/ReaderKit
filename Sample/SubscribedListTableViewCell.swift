//
//  SubscribedListTableViewCell.swift
//  ReaderKit
//
//  Created by chocoyama on 2016/10/31.
//  Copyright © 2016年 chocoyama. All rights reserved.
//

import UIKit
import ReaderKit

class SubscribedListTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var linkLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with document: Document) {
        titleLabel.text = document.title
        linkLabel.text = document.link.absoluteString
    }

}
