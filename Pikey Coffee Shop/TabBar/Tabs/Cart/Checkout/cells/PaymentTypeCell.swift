//
//  PaymentTypeCell.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 21/06/2022.
//

import UIKit

class PaymentTypeCell: UITableViewCell {
    
    @IBOutlet weak var rowOneBullet: UIView!
    @IBOutlet weak var rowTwoBullet: UIView!
    @IBOutlet weak var rowTwoView: UIStackView!
    
    var onTypeChange: ((_: PaymentType) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func onClickRow(_ sender: UIButton!) {
        configureRows(sender.tag)
    }
    
    func configureRows(_ tag: Int) {
        if tag == 1 {
            rowOneBullet.backgroundColor = .white
            rowTwoBullet.backgroundColor = .clear
            onTypeChange?(.applePay)
        } else {
            rowOneBullet.backgroundColor = .clear
            rowTwoBullet.backgroundColor = .white
            onTypeChange?(.cash)
        }
    }
    
}

enum PaymentType {
    case applePay
    case cash
}
