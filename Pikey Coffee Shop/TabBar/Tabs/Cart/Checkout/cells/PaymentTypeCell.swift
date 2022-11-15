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

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func onClickRow(_ sender: UIButton!) {
        if sender.tag == 1 {
            rowOneBullet.backgroundColor = .white
            rowTwoBullet.backgroundColor = .clear
        } else {
            rowOneBullet.backgroundColor = .clear
            rowTwoBullet.backgroundColor = .white
        }
    }
    
}
