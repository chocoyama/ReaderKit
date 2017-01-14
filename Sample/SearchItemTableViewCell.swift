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

    private var item: DocumentItem?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(item: DocumentItem) {
        self.item = item
        titleLabel.text = item.title
        descLabel.text = item.desc
        thumbnailView.image = nil
        
        DispatchQueue.global().async { [weak self] in
            self?.item?.getImages(fetchSize: true, completion: { (images) in
                let imageUrl = images
                    .filter{ $0.imageSize != nil }
                    .filter{ $0.imageSize!.width > 500 && $0.imageSize!.height > 500 }
                    .first?
                    .imageUrl
                
                DispatchQueue.global().async {
                    if let imageUrl = imageUrl,
                        let imageData = try? Data.init(contentsOf: imageUrl) {
                        let image = UIImage(data: imageData)
                        DispatchQueue.main.async {
                            self?.thumbnailView.image = image
                        }
                    }
                }
            })
        }
    }

}
