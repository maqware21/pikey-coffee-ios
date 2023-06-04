//
//  OrderPickupTypeCell.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 04/06/2023.
//

import UIKit

class OrderPickupTypeCell: UITableViewCell {

    @IBOutlet weak var rowOneBullet: UIView!
    @IBOutlet weak var rowTwoBullet: UIView!
    @IBOutlet weak var rowThreeBullet: UIView!
    var selectedType: OrderTypeState = .future
    
    var stateSelected: ((OrderTypeState) -> Void)?

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
            rowThreeBullet.backgroundColor = .clear
            selectedType = .now
            stateSelected?(selectedType)
        } else if tag == 2 {
            rowOneBullet.backgroundColor = .clear
            rowTwoBullet.backgroundColor = .white
            rowThreeBullet.backgroundColor = .clear
            selectedType = .future
            stateSelected?(selectedType)
        } else {
            rowOneBullet.backgroundColor = .clear
            rowTwoBullet.backgroundColor = .clear
            rowThreeBullet.backgroundColor = .white
            selectedType = .delivery
            stateSelected?(selectedType)
        }
    }
    
}

enum OrderTypeState {
    case now
    case future
    case delivery
}
