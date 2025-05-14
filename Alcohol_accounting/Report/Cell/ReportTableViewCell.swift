//
//  ReportTableViewCell.swift
//  Alcohol_accounting
//
//  Created by Karen Khachatryan on 06.11.24.
//

import UIKit

class ReportTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        dateLabel.font = .montserratRegular(size: 15)
        nameLabel.font = .montserratRegular(size: 15)
        quantityLabel.font = .montserratRegular(size: 15)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(quantityChange: QuantityChangeModel) {
        dateLabel.text = quantityChange.date?.toString()
        nameLabel.text = quantityChange.name
        quantityLabel.text = "\(quantityChange.amount ?? 0)"
    }
    
}
