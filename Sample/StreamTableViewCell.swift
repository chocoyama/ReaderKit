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

    @IBOutlet weak var feedTitleLabel: UILabel!
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

    func configure(for item: DocumentItem) {
        self.item = item
        feedTitleLabel.text = item.documentTitle
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
