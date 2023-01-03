//
//  CartCell.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 14/06/2022.
//

import UIKit
import Kingfisher

typealias QuantityChangedCallback = ((Int) -> Void)
typealias CartRemoveCallback = (() -> Void)

class CartCell: UITableViewCell {

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var quantityPriceLabel: UILabel!
    @IBOutlet weak var counterPlus: CartConterItem!
    @IBOutlet weak var counterMinus: CartConterItem!
    @IBOutlet weak var counterLabel: CartConterItem!
    
    var quantity = 1
    var quantityCallback: QuantityChangedCallback?
    var cartRemoveCallback: CartRemoveCallback?
    
    var product: Product? {
        didSet {
            guard let product else {return}
            if let url = URL(string: product.images?.first?.path ?? "") {
                productImage.kf.setImage(with: url)
            }
            nameLabel.text = "\(product.name ?? "") (\(product.addons?.first?.name ?? "Small"))"
            quantityLabel.text = "x \(product.selectedQuantity ?? 0)"
            let price = String(format: "%.2f", ((product.price ?? 0) + (product.addons?.first?.price ?? 0)) )
            let totalPrice = String(format: "%.2f", ((product.price ?? 0) + (product.addons?.first?.price ?? 0)) * (Double(product.selectedQuantity ?? 0)))
            quantityPriceLabel.text = "$\(price) x \(product.selectedQuantity ?? 0) = $\(totalPrice)"
            counterLabel.label.text = "\(product.selectedQuantity ?? 0)"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        counterPlus.type = .image
        counterPlus.imageView.image = UIImage(named: "PlusIcon")
        counterMinus.type = .image
        counterMinus.imageView.image = UIImage(named: "MinusIcon")
        counterLabel.type = .label
        counterPlus.clickedAction = {[weak self] in
            self?.onClickCounter(.plus)
        }
        
        counterMinus.clickedAction = {[weak self] in
            self?.onClickCounter(.negetive)
        }
    }
    
    
    func onClickCounter(_ option: CounterOptions) {
        let value = Int(counterLabel.label.text!)!
        switch option {
        case .plus:
            let quantity = value + 1
            counterLabel.label.text = "\(quantity)"
            self.quantity = quantity
        case .negetive:
            if value > 1 {
                let quantity = value - 1
                counterLabel.label.text = "\(quantity)"
                self.quantity = quantity
            } else {
                self.quantity = 1
            }
        }
        product?.selectedQuantity = quantity
        quantityCallback?(quantity)
    }
    
    @IBAction func onClickRemove() {
        cartRemoveCallback?()
    }
}
