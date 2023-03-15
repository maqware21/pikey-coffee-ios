//
//  OrderedItemsCell.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 14/03/2023.
//

import UIKit

class OrderedItemsCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var originalPriceView: UIView!
    @IBOutlet weak var originalPriceLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
}
