//
//  CheckoutCodeCell.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 04/06/2023.
//

import UIKit

class CheckoutCodeCell: UITableViewCell {

    @IBOutlet weak var codeField: UITextField!
    @IBOutlet weak var applyButton: UIButton!
    
    var onApply: ((String) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onClickApply() {
        onApply?(codeField.text ?? "0")
    }
}
