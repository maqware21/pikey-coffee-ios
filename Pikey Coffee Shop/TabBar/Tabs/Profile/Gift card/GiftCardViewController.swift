//
//  GiftCardViewController.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 21/05/2023.
//

import UIKit
import PassKit

class GiftCardViewController: EditProfileBaseViewController {

    @IBOutlet weak var amountView: UIView!
    @IBOutlet weak var amountViewHeight: NSLayoutConstraint!
    @IBOutlet weak var customAmountView: UIView!
    @IBOutlet weak var amountViewBottom: NSLayoutConstraint!
    @IBOutlet weak var customAmountViewBottom: NSLayoutConstraint!
    @IBOutlet weak var tenDollarCheck: UIView!
    @IBOutlet weak var fifteenDollarCheck: UIView!
    var paymentToken: String?
    @IBOutlet weak var senderName: UITextField!
    @IBOutlet weak var senderEmail: UITextField!
    @IBOutlet weak var recipientName: UITextField!
    @IBOutlet weak var recipientEmail: UITextField!
    @IBOutlet weak var customAmount: UITextField!
    @IBOutlet weak var messageField: UITextView!
    
    var viewModel = GiftCardViewModel()
    
    var amount: Double = 0.0
    
    private var paymentRequest: PKPaymentRequest = {
        let request = PKPaymentRequest()
        request.merchantIdentifier = "merchant.com.pikeycoffee.pikey"
        request.supportedNetworks = [.visa, .masterCard,.amex,.discover]
        request.supportedCountries = ["US"]
        request.merchantCapabilities = .capability3DS
        request.countryCode = "US"
        request.currencyCode = "USD"
        return request
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        amountView.isHidden = true
        amountViewHeight.constant = 0
        customAmountView.isHidden = true
        amountViewBottom.priority = .required
        customAmountViewBottom.priority = .defaultHigh
        viewModel.delegate = self
        // Do any additional setup after loading the view.
    }

    @IBAction func oncClickBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickAmount() {
        amountView.isHidden = !amountView.isHidden
        amountViewHeight.constant = amountView.isHidden ? 0 : 120
        customAmountView.isHidden = true
        amountViewBottom.priority = .required
        customAmountViewBottom.priority = .defaultHigh
    }
    
    @IBAction func onClickCustom() {
        amountView.isHidden = true
        amountViewHeight.constant = 0
        customAmountView.isHidden = false
        amountViewBottom.priority = .defaultHigh
        customAmountViewBottom.priority = .required
        self.amount = 0
    }
    
    @IBAction func onClickDefaultAmount(_ sender: UIButton!) {
        self.tenDollarCheck.isHidden = !(sender.tag == 10)
        self.fifteenDollarCheck.isHidden = !(sender.tag == 15)
        self.amount = Double(sender.tag)
    }
    
    @IBAction func onClickCheckout() {
        self.purchase()
    }
}


extension GiftCardViewController: PKPaymentAuthorizationViewControllerDelegate {
    
    func purchase() {
        if self.validate() {
            let total: Double = self.amount == 0 ? Double(self.customAmount.text ?? "0") ?? 0 : self.amount
            
            paymentRequest.paymentSummaryItems = [PKPaymentSummaryItem(label: "Pickey order", amount: NSDecimalNumber(floatLiteral: total))]
            if let controller = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest) {
                controller.delegate = self
                self.present(controller, animated: true, completion: nil)
            }
        }
    }
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        self.paymentToken = payment.token.transactionIdentifier
        completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
    }
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion:  {
            let total: Double = self.amount == 0 ? Double(self.customAmount.text ?? "0")! : self.amount
            
            let giftCard = GiftCard(paymentMethod: 3, token: self.paymentToken, gift: Gift(toName: self.recipientName.text ?? "", fromName: self.senderName.text ?? "", toEmail: self.recipientEmail.text ?? "", fromEmail: self.senderEmail.text ?? "", amount: total, message: self.messageField.text ?? ""))
            self.showLoader()
            self.viewModel.createGiftCard(giftCard: giftCard)
        })
    }
    
    func validate() -> Bool {
        if self.recipientName.isEmpty {
            self.view.displayNotice(with: "Kindly fill all the fields")
            return false
        }
        if self.recipientEmail.isEmpty && self.recipientEmail.hasValidEmail {
            self.view.displayNotice(with: "Kindly fill all the fields")
            return false
        }
        if self.senderName.isEmpty {
            self.view.displayNotice(with: "Kindly fill all the fields")
            return false
        }
        if self.senderEmail.isEmpty && self.recipientEmail.hasValidEmail {
            self.view.displayNotice(with: "Kindly fill all the fields")
            return false
        }
        
        let total: Double = self.amount == 0 ? Double(self.customAmount.text ?? "0")! : self.amount
        if total == 0 {
            self.view.displayNotice(with: "Kindly add the amount")
            return false
        }
        
        return true
    }
}

extension GiftCardViewController: GiftCardDelegate {
    
    func giftCardCreated(_ error: Error?) {
        DispatchQueue.main.async {
            self.removeLoader()
            if let error {
                self.view.displayNotice(with: error.localizedDescription)
            }
            
            self.view.displayNotice(with: "Gift card created")
            self.navigationController?.popViewController(animated: true)
        }
    }
}
