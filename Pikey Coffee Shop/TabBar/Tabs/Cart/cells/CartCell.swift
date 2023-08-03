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
            
            var modifiersCollectivePrice: Double = 0
            let attributedText = NSMutableAttributedString(string: "\(product.name ?? "") (\(product.addons?.first?.name ?? "Small"))", attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .semibold)])
            for modifier in product.modifiers ?? [] where modifier?.selectedOption != nil {
                let secondString = NSMutableAttributedString(string: "\n\(modifier?.name ?? "") - \(modifier?.selectedOption?.name ?? "") \n = $\(modifier?.selectedOption?.price ?? 0)", attributes: [.font: UIFont.systemFont(ofSize: 14)])
                attributedText.append(secondString)
                modifiersCollectivePrice += modifier?.selectedOption?.price ?? 0
            }
            nameLabel.attributedText = attributedText
            quantityLabel.text = "x \(product.selectedQuantity ?? 0)"
            let price = String(format: "%.2f", ((product.price ?? 0) + (product.addons?.first?.price ?? 0) + modifiersCollectivePrice))
            let totalPrice = String(format: "%.2f", ((product.price ?? 0) + (product.addons?.first?.price ?? 0) + modifiersCollectivePrice) * (Double(product.selectedQuantity ?? 0)))
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
