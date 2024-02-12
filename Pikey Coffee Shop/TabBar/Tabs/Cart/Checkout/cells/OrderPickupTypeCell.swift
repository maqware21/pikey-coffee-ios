//
//  OrderPickupTypeCell.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 04/06/2023.
//

import UIKit

class OrderPickupTypeCell: UITableViewCell {

    @IBOutlet weak var deliveryCell: UIButton!
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
    
    @IBAction func dLabel(_ sender: Any) {
    }
    func configureRows(_ tag: Int) {
        deliveryCell.isHidden =  true
        rowThreeBullet.isHidden =  true
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
              print("test")
//            rowOneBullet.backgroundColor = .clear
//            rowTwoBullet.backgroundColor = .clear
//            rowThreeBullet.backgroundColor = .white
//            selectedType = .delivery
//            stateSelected?(selectedType)
        }
    }
    
}

enum OrderTypeState: Int {
    case now = 0
    case future = 1
    case delivery = 2
}
