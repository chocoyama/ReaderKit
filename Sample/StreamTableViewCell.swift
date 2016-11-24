//
//  StreamTableViewCell.swift
//  ReaderKit
//
//  Created by takyokoy on 2016/11/24.
//  Copyright © 2016年 chocoyama. All rights reserved.
//

import UIKit
import ReaderKit

class StreamTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var thumbnailView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configure(item: Document.Item) {
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
