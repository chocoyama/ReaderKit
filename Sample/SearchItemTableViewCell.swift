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
        
        DispatchQueue.global(qos: .default).async { [weak self] in
            self?.thumbnailView.image = nil
            item.getImages(fetchSize: false, completion: { (images) in
                if let imageUrl = images.first?.imageUrl,
                    let imageData = try? Data.init(contentsOf: imageUrl) {
                    let image = UIImage(data: imageData)
                    DispatchQueue.main.async {
                        self?.thumbnailView.image = image
                    }
                }
            })
        }
    }

}
