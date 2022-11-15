//
//  MyAddressCell.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 15/06/2022.
//

import UIKit

typealias AddressSelectedCallback = (() -> Void)

class MyAddressCell: UITableViewCell {

    @IBOutlet weak var containerView: HorizontalGradientView!
    @IBOutlet weak var editView: HorizontalGradientView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var addressIcon: UIImageView!
    @IBOutlet weak var editIcon: UIImageView!
    var callback: AddressSelectedCallback?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.borderColor = UIColor(named: "shadowColor")
        editView.borderColor = UIColor(named: "shadowColor")
        addressIcon.image = UIImage(named: "homeAddressIcon")?.withRenderingMode(.alwaysTemplate)
        editIcon.image = UIImage(named: "editIcon")?.withRenderingMode(.alwaysTemplate)
    }
    
    var address: PickeyAddress? {
        didSet {
            guard let address else {return}
            name.text = address.name
            addressLabel.text = address.address
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            self.containerView.borderWidth = 0
            self.containerView.backgroundColor = .white
            self.editView.borderWidth = 0
            self.editView.backgroundColor = .white
            self.name.textColor = .black
            self.addressLabel.textColor = UIColor(hex: "333333")
            self.addressIcon.tintColor = .black
            self.editIcon.tintColor = .black
            self.containerView.gradient.isHidden = false
            self.editView.gradient.isHidden = false
            self.callback?()
        } else {
            self.containerView.borderWidth = 1
            self.containerView.backgroundColor = .black
            self.editView.borderWidth = 1
            self.editView.backgroundColor = .black
            self.name.textColor = .white
            self.addressLabel.textColor = UIColor(named: "coffeeGray")
            self.addressIcon.tintColor = .white
            self.editIcon.tintColor = UIColor(named: "coffeeGray")
            self.containerView.gradient.isHidden = true
            self.editView.gradient.isHidden = true
        }
    }
}
