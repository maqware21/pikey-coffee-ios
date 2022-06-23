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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
