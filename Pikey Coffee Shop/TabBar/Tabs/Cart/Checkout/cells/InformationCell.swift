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
    @IBOutlet weak var addressPlaceholderView: UIView!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var deliveryDetailsView: UIView!
    
    var user = UserDefaults.standard[.user]
    var address: PickeyAddress? {
        didSet {
            guard let address else {
                addressPlaceholderView.isHidden = false
                return
            }
            addressPlaceholderView.isHidden = true
            addressLabel.text = address.address
        }
    }
    var callback: InformationEditCallback?
    
    var selectedType: OrderTypeState? {
        didSet {
            guard let selectedType else { return }
            self.deliveryDetailsView.isHidden = selectedType != .delivery
            self.separatorView.isHidden = selectedType != .delivery
        }
    }
    
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
