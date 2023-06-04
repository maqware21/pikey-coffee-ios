//
//  PaymentTypeCell.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 21/06/2022.
//

import UIKit
import PassKit

class PaymentTypeCell: UITableViewCell {
    
    @IBOutlet weak var rowOneBullet: UIView!
    @IBOutlet weak var rowTwoBullet: UIView!
    @IBOutlet weak var rowTwoView: UIStackView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var total: Double!
    
    var products: [Product]? {
        didSet {
            guard let products else {return}
            var subTotal = 0.0
            let discount = 0.0
            let dileveryCharges = 0.0
            products.forEach { product in
                subTotal += ((product.price ?? 0) + (product.addons?.first?.price ?? 0)) * (Double(product.selectedQuantity ?? 0))
            }
            total = subTotal + discount + dileveryCharges
        }
    }
    
    private var paymentRequest: PKPaymentRequest = {
        let request = PKPaymentRequest()
        request.merchantIdentifier = "merchant.pickeyCoffeeMerchantID"
        request.supportedNetworks = [.visa, .masterCard,.amex,.discover]
        request.supportedCountries = ["US"]
        request.merchantCapabilities = .capability3DS
        request.countryCode = "US"
        request.currencyCode = "USD"
        return request
    }()
    
    func purchase() {
        paymentRequest.paymentSummaryItems = [PKPaymentSummaryItem(label: "Pickey order", amount: NSDecimalNumber(floatLiteral: total))]
        if let controller = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest) {
            controller.delegate = self
            self.parentViewController?.present(controller, animated: true, completion: nil)
        }
    }
    
    @IBAction func onClickRow(_ sender: UIButton!) {
        configureRows(sender.tag)
    }
    
    func configureRows(_ tag: Int) {
        if tag == 1 {
            rowOneBullet.backgroundColor = .white
            rowTwoBullet.backgroundColor = .clear
            purchase()
        } else {
            rowOneBullet.backgroundColor = .clear
            rowTwoBullet.backgroundColor = .white
        }
    }
    
}

extension PaymentTypeCell: PKPaymentAuthorizationViewControllerDelegate {
 
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
    }
 
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
 
}
