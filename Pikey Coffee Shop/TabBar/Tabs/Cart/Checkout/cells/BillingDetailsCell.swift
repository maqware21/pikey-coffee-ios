//
//  BillingDetailsCell.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 21/06/2022.
//

import UIKit

class BillingDetailsCell: UITableViewCell {

    @IBOutlet var nameLabels: [UILabel]!
    @IBOutlet var valueLabels: [UILabel]!
    @IBOutlet weak var availStack: UIStackView!
    @IBOutlet weak var discountView: UIStackView!
    @IBOutlet weak var deliveryChargesView: UIStackView!
    @IBOutlet weak var tipChargesView: UIStackView!
    @IBOutlet weak var couponCodeView: UIStackView!
    var tipAmount: Double = 0.0
    
    var products: [Product]? {
        didSet {
            guard let products else {return}
            var subTotal = 0.0
            let discount = 0.0
            let dileveryCharges = pickupType == .delivery ? 10.0 : 0.0
            products.forEach { product in
                let modifierPrice = product.modifiers?.reduce(0) {$0 + ($1?.selectedOption?.price ?? 0)}
                let productTotal = ((product.price ?? 0) + (product.addons?.first?.price ?? 0) + (modifierPrice ?? 0))
                subTotal += productTotal * (Double(product.selectedQuantity ?? 0))
            }
            valueLabels[0].text = String(format: "$%.2f", Float(subTotal))
            valueLabels[1].text = String(format: "$%.2f", Float(discount))
            valueLabels[2].text = String(format: "$%.2f", Float(dileveryCharges))
            var total = Double(subTotal + discount + dileveryCharges + tipAmount)
            if let couponValidated = couponValidated {
                total -= couponValidated.discountAmount ?? 0
                total -= ((couponValidated.discountPercentage ?? 0)/100) * total
            }
            valueLabels[5].text = String(format: "$%.2f", Float(total))
        }
    }
    
    var pickupType: OrderTypeState? {
        didSet {
            switch pickupType {
            case .now, .future:
                deliveryChargesView.isHidden = true
            default:
                deliveryChargesView.isHidden = true
            }
        }
    }
    
    var tip: String? {
        didSet {
            tipChargesView.isHidden = false
            let tipArray = tip?.components(separatedBy: CharacterSet.decimalDigits.inverted)
            for item in tipArray ?? [] {
                if let number = Int(item) {
                    self.tipAmount = Double(number)
                    valueLabels[3].text = String(format: "$%.2f", Float(number))
                }
            }
        }
    }
    
    var code: String? {
        didSet {
            couponCodeView.isHidden = false
            valueLabels[6].text = code ?? ""
        }
    }
    
    var couponValidated: CouponValidated?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let text = "Avail Points"
        
        valueLabels[4].tappableLabels(string: text,
                                      tappableStrings: ["Avail Points"],
                                      textColor: .white,
                                      isUnderLined: true)
        
        valueLabels[4].addRangeGesture(stringRange: "Avail Points") { _ in
            print("avail clicked")
        }
        
        availStack.isHidden = true
        discountView.isHidden = true
        tipChargesView.isHidden = true
        couponCodeView.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
