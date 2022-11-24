//
//  MyAddressCell.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 15/06/2022.
//

import UIKit

typealias AddressSelectedCallback = (() -> Void)
typealias AddressCallbackWithId = ((Int?, AddressAction) -> Void)

class MyAddressCell: UITableViewCell {

    @IBOutlet weak var containerView: HorizontalGradientView!
    @IBOutlet weak var editView: UIView!
    @IBOutlet weak var deleteView: UIView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var addressIcon: UIImageView!
    var callback: AddressSelectedCallback?
    var idCallback: AddressCallbackWithId?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.borderColor = UIColor(named: "shadowColor")
        addressIcon.image = UIImage(named: "homeAddressIcon")?.withRenderingMode(.alwaysTemplate)
        let tap = UITapGestureRecognizer(target: self, action: #selector(onClickContainer))
        containerView.addGestureRecognizer(tap)
    }
    
    var address: PickeyAddress? {
        didSet {
            guard let address else {return}
            name.text = address.name
            addressLabel.text = address.address
            showSelected()
        }
    }
    
    func showSelected() {
        if let savedAddress = UserDefaults.standard[.selectedAddress], savedAddress.id == address?.id {
            self.containerView.borderWidth = 0
            self.containerView.backgroundColor = .white
            self.name.textColor = .black
            self.addressLabel.textColor = UIColor(hex: "333333")
            self.addressIcon.tintColor = .black
            self.containerView.gradient.isHidden = false
        } else {
            self.containerView.borderWidth = 1
            self.containerView.backgroundColor = .black
            self.name.textColor = .white
            self.addressLabel.textColor = UIColor(named: "coffeeGray")
            self.addressIcon.tintColor = .white
            self.containerView.gradient.isHidden = true
        }
    }
    
    @objc func onClickContainer() {
        self.callback?()
    }
    
    @IBAction func onClickEdit() {
        idCallback?(address?.id, .edit)
    }
    
    @IBAction func onClickDelete() {
        idCallback?(address?.id, .delete)
    }
}

enum AddressAction {
    case edit
    case delete
}
