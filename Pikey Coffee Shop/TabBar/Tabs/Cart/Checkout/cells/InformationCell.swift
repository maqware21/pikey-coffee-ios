//
//  InformationCell.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 18/06/2022.
//

import UIKit

class InformationCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!

    var user = UserDefaults.standard[.user]
    var address = UserDefaults.standard[.addresses]?.data?.first
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.text = user?.name
        numberLabel.text = user?.phoneNumber
        addressLabel.text = address?.address
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
