//
//  InformationCell.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 18/06/2022.
//

import UIKit

typealias InformationEditCallback = (() -> Void)

class InformationCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!

    var user = UserDefaults.standard[.user]
    var address: PickeyAddress? {
        didSet {
            addressLabel.text = address?.address
        }
    }
    var callback: InformationEditCallback?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.text = user?.name
        numberLabel.text = user?.phoneNumber
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onClickEdit() {
        callback?()
    }
    
}
