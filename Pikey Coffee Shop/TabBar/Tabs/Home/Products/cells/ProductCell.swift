//
//  ProductCell.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 23/06/2022.
//

import UIKit

class ProductCell: UICollectionViewCell {
    
    @IBOutlet weak var cartButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var originalPriceView: UIView!
    @IBOutlet weak var originalPriceLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var product: Product? {
        didSet {
            guard let product else {
                return
            }
            
            if let url = URL(string: product.images?.first?.path ?? "") {
                productImage.kf.setImage(with: url)
            }
            nameLabel.text = product.name
            priceLabel.text = "$\(product.price ?? 0)"
            originalPriceView.isHidden = true
        }
    }

}
