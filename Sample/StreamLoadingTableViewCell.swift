//
//  StreamLoadingTableViewCell.swift
//  ReaderKit
//
//  Created by takyokoy on 2016/11/25.
//  Copyright © 2016年 chocoyama. All rights reserved.
//

import UIKit

class StreamLoadingTableViewCell: UITableViewCell {

    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func animateIndicator() {
        indicator.startAnimating()
    }

}
