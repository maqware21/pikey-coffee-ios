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

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    private var paymentRequest: PKPaymentRequest = {
            let request = PKPaymentRequest()
            request.merchantIdentifier = "merchant.com..."
            request.supportedNetworks = [.visa, .masterCard,.amex,.discover]
            request.supportedCountries = ["UA"]
            request.merchantCapabilities = .capability3DS
            request.countryCode = "UA"
            request.currencyCode = "UAH"
            request.paymentSummaryItems = [PKPaymentSummaryItem(label: "App test", amount: 10.99)]
            return request
        }()
    
    func purchase() {
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
        configureRows(2)
        controller.dismiss(animated: true, completion: nil)
    }
 
}
