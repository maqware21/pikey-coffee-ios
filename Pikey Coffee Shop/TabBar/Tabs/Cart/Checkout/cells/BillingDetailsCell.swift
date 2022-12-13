//
//  BillingDetailsCell.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 21/06/2022.
//

import UIKit

class BillingDetailsCell: UITableViewCell {

    @IBOutlet var nameLabels: [UILabel]!
    @IBOutlet var valueLabels: [UILabel]!
    @IBOutlet weak var availStack: UIStackView!
    
    var products: [Product]? {
        didSet {
            guard let products else {return}
            var subTotal = 0.0
            let discount = 0.0
            let dileveryCharges = 0.0
            products.forEach { product in
                subTotal += (product.price ?? 0) * (Double(product.selectedQuantity ?? 0))
            }
            
            valueLabels[0].text = String(format: "$%.2f", Float(subTotal))
            valueLabels[1].text = String(format: "$%.2f", Float(discount))
            valueLabels[2].text = String(format: "$%.2f", Float(dileveryCharges))
            valueLabels[4].text = String(format: "$%.2f", Float(subTotal + discount + dileveryCharges))
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let text = "Avail Points"
        
        valueLabels[3].tappableLabels(string: text,
                                      tappableStrings: ["Avail Points"],
                                      textColor: .white,
                                      isUnderLined: true)
        
        valueLabels[3].addRangeGesture(stringRange: "Avail Points") {
            print("avail clicked")
        }
        
        availStack.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
