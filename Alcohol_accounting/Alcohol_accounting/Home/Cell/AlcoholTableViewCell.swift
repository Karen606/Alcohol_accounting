//
//  AlcoholTableViewCell.swift
//  Alcohol_accounting
//
//  Created by Karen Khachatryan on 05.11.24.
//

import UIKit

protocol AlcoholTabelViewCellDelegate: AnyObject {
    func increment(by id: UUID)
    func decrement(by id: UUID)
}

class AlcoholTableViewCell: UITableViewCell {

    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    weak var delegate: AlcoholTabelViewCellDelegate?
    private var id: UUID?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.layer.cornerRadius = 20
        bgView.layer.borderColor = UIColor.black.withAlphaComponent(0.2).cgColor
        bgView.layer.borderWidth = 0.1
        typeLabel.font = .poppinsLight(size: 20)
        nameLabel.font = .poppinsLight(size: 20)
        quantityLabel.font = .poppinsMedium(size: 25)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(alcohol: AlcoholModel) {
        id = alcohol.id
        typeLabel.text = "\(alcohol.type ?? "") \(alcohol.volume?.formattedToString() ?? "") l"
        nameLabel.text = alcohol.name
        quantityLabel.text = "\(alcohol.quantity ?? 0)"
    }
    
    override func prepareForReuse() {
        id = nil
    }
    
    @IBAction func clickedMinus(_ sender: UIButton) {
        if let id = id {
            delegate?.decrement(by: id)
//            HomeViewModel.shared.decrementAlcoholQuantity(for: id) { [weak self] error in
//                if let self = self, error == nil {
//                    self.
//                }
//            }
        }
    }
    
    @IBAction func clickedPlus(_ sender: UIButton) {
        if let id = id {
            delegate?.increment(by: id)
//            HomeViewModel.shared.incrementAlcoholQuantity(for: id, completion: <#T##((any Error)?) -> Void#>)
        }
    }
}
