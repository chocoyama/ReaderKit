//
//  SubscribedListTableViewCell.swift
//  ReaderKit
//
//  Created by chocoyama on 2016/10/31.
//  Copyright © 2016年 chocoyama. All rights reserved.
//

import UIKit
import ReaderKit

protocol SubscribedListTableViewCellDelegate: class {
    func didUnsubscribed(document: Document)
}

class SubscribedListTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var linkLabel: UILabel!
    
    weak var delegate: SubscribedListTableViewCellDelegate?
    
    private var documentSummary: DocumentSummary? {
        didSet { update() }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with documentSummary: DocumentSummary) {
        self.documentSummary = documentSummary
    }
    
    private func update() {
        guard let summary = documentSummary else { return }
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.titleLabel.text = summary.title
            strongSelf.linkLabel.text = summary.link.absoluteString
        }
    }

    @IBAction func didTappedUnsubscribeButton(_ sender: UIButton) {
        guard let documentLink = documentSummary?.link,
            let document = DocumentRepository.shared.get(documentLink) else { return }
        do {
            try document.unSubscribe()
            delegate?.didUnsubscribed(document: document)
        } catch {}
    }
}
