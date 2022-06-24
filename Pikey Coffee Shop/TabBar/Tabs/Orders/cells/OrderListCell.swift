//
//  OrderListCell.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 08/06/2022.
//

import UIKit

protocol OrderCellDelegate: AnyObject {
    func presentOnCell()
}

class OrderListCell: UITableViewCell {

    weak var delegate: OrderCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onClickButton() {
        delegate?.presentOnCell()
    }
}
