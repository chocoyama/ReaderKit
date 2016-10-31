//
//  SearchItemTableViewCell.swift
//  ReaderKit
//
//  Created by chocoyama on 2016/10/30.
//  Copyright © 2016年 chocoyama. All rights reserved.
//

import UIKit
import ReaderKit

class SearchItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var thumbnailView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(item: DocumentItem) {
        titleLabel.text = item.title
        descLabel.text = item.desc
        
        thumbnailView.image = nil
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            if let image = item.nonFetchedImages.first {
                image.fetch({ [weak self] (image) in
                    DispatchQueue.main.async {
                        self?.thumbnailView.image = image.fetchResult?.image
                    }
                })
            } else {
                self?.thumbnailView.image = nil
            }
        }
    }

}
