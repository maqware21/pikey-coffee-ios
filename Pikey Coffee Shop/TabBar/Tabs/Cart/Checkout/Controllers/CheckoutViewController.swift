//
//  CheckoutViewController.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 17/06/2022.
//

import UIKit
import PassKit

protocol CheckoutAddressUpdateDelegate: AnyObject {
    func addressUpdated()
}

class CheckoutViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    @IBOutlet var textView : UITextView!
    var placeholderLabel : UILabel!
    
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
    
    weak var delegate: CartDelegate?
    let viewModel = CheckOutViewModel()
    var products = [Product]()
    var address = UserDefaults.standard[.selectedAddress]
    var selectedType: OrderTypeState!
    var tip: String = "0"
    var couponCode: String = ""
    var paymentToken: String = ""
    var selectedPaymentType: PaymentType? = .applePay
    var couponValidated: CouponValidated?

    override func viewDidLoad() {
        super.viewDidLoad()
        products = UserDefaults.standard[.cart] ?? []
        tableView.delegate = self
        tableView.dataSource = self
        viewModel.delegate = self
        tableView.register(UINib(nibName: "PaymentTypeCell", bundle: .main), forCellReuseIdentifier: "paymentTypeCell")
        tableView.register(UINib(nibName: "BillingDetailsCell", bundle: .main), forCellReuseIdentifier: "billingDetailsCell")
        tableView.register(UINib(nibName: "CheckoutCodeCell", bundle: .main), forCellReuseIdentifier: "CheckoutCodeCell")
        tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        textViewPlaceholder()
        textView.addDoneOnKeyboardWithTarget(self, action: #selector(resignKeyboard), titleText: "Done")
        // Do any additional setup after loading the view.
    }
    
    func textViewPlaceholder() {
        textView.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.text = "Write here..."
        placeholderLabel.font = textView.font
        placeholderLabel.textColor = UIColor(named: "coffeeGray")
        placeholderLabel.sizeToFit()
        textView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (textView.font?.pointSize)! / 2)
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
    deinit {
        tableView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if(keyPath == "contentSize"){
            if let newvalue = change?[.newKey]
            {
                let newsize  = newvalue as! CGSize
               tableHeight.constant = newsize.height + 16
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        
    }
    
    @IBAction func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickPlaceOrder() {
        switch selectedPaymentType {
        case .applePay:
            self.purchase()
        default:
            self.placeOrder()
        }
    }
    
    func placeOrder() {
        if let address = UserDefaults.standard[.selectedAddress] {
            let items = products.compactMap { product in
                return Item(productID: product.id,
                            quantity: product.selectedQuantity,
                            addons: product.addons?.compactMap({ addOn in
                    return Item(productID: addOn.id,
                                quantity: addOn.selectedQuantity,
                                addons: nil)
                }))
            }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = dateFormatter.string(from: Date())
            
            let method = selectedPaymentType == .applePay ? 3 : 0
            
            let cart = Cart(paymentMethod: method, token: self.paymentToken, type: selectedType.rawValue, userComment: self.textView.text ?? "", locationID: address.id, deliveryDate: date, items: items, tip: Int(self.tip), promoCode: self.couponCode)
            self.showLoader()
            viewModel.createOrder(cart: cart)
        } else {
            self.view.displayNotice(with: "kindly add your location/address")
            self.moveToMyAddresses()
        }
    }
    
    @objc func resignKeyboard() {
        self.textView.resignFirstResponder()
    }
}


extension CheckoutViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 4
        view.backgroundColor = .black
        view.layoutMargins = UIEdgeInsets(top: 8, left: 16, bottom: 16, right: 0)
        view.isLayoutMarginsRelativeArrangement = true
        
        let headline = UILabel()
        switch section {
        case 0:
            headline.text = "Payment Details"
        case 1:
            headline.text = "Add Coupon Code"
        case 2:
            headline.text = "Add Tip"
        case 3:
            headline.text = "Billing Details"
        default:
            break
        }
        headline.font = UIFont.systemFont(ofSize: 24)
        headline.textColor = .white
        view.addArrangedSubview(headline)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return paymentTypeCell(tableView, cellForRowAt: indexPath)
        case 1:
            return couponCell(tableView, cellForRowAt: indexPath)
        case 2:
            return tipCell(tableView, cellForRowAt: indexPath)
        case 3:
            return billingDetailsCell(tableView, cellForRowAt: indexPath)
        default:
            return UITableViewCell()
        }
    }
    
    func moveToMyAddresses() {
        if let vc = UIStoryboard(name: "Profile", bundle: .main).instantiateViewController(withIdentifier: "MyAddressesViewController") as? MyAddressesViewController {
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func couponCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CheckoutCodeCell", for: indexPath) as! CheckoutCodeCell
        cell.onApply = {[weak self] value in
            self?.couponCode = value
            self?.showLoader()
            self?.viewModel.validateCoupon(code: value)
        }
        return cell
    }
    
    func tipCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CheckoutCodeCell", for: indexPath) as! CheckoutCodeCell
        cell.codeField.placeholder = "Enter Tip"
        cell.applyButton.setTitle("Enter", for: .normal)
        cell.onApply = {[weak self] value in
            self?.tip = value
            self?.tableView.reloadData()
        }
        return cell
    }
    
    func paymentTypeCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "paymentTypeCell", for: indexPath) as! PaymentTypeCell
        if selectedType == .now {
            cell.rowTwoView.isHidden = true
        } else {
            cell.rowTwoView.isHidden = false
        }
        
        cell.onTypeChange = {[weak self] type in
            guard let self else {return}
            self.selectedPaymentType = type
        }
        return cell
    }
    
    func billingDetailsCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "billingDetailsCell", for: indexPath) as! BillingDetailsCell
        cell.pickupType = selectedType
        cell.tip = self.tip
        cell.code = self.couponCode
        cell.couponValidated = couponValidated
        cell.products = products
        return cell
    }
    
}

extension CheckoutViewController : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
}

extension CheckoutViewController: CheckOutDelegate, CheckoutAddressUpdateDelegate {
    func orderCreated(_ order: Order?) {
        DispatchQueue.main.async {
            self.removeLoader()
            guard let _ = order else {
                self.view.displayNotice(with: "Order couldn't be created")
                return
            }
            UserDefaults.standard[.cart] = []
            self.view.displayNotice(with: "Your order is placed")
            self.moveToOrders()
        }
    }
    
    func moveToOrders() {
        (self.navigationController?.presentingViewController as? UINavigationController)?.viewControllers.forEach({ viewController in
            if viewController is UITabBarController, let vc = viewController as? UITabBarController {
                vc.selectedIndex = 1
                self.navigationController?.presentingViewController?.dismiss(animated: true)
                (self.navigationController?.presentingViewController as? UINavigationController)?.popToViewController(vc, animated: true)
                
            }
        })
    }
    
    func addressUpdated() {
        self.address = UserDefaults.standard[.selectedAddress]
        tableView.reloadData()
    }
    
    func couponValidated(_ couponValidated: CouponValidated?) {
        DispatchQueue.main.async {
            self.removeLoader()
            self.couponValidated = couponValidated
            self.tableView.reloadData()
        }
    }
}


extension CheckoutViewController: PKPaymentAuthorizationViewControllerDelegate {
    
    func purchase() {
        var subTotal = 0.0
        let discount = 0.0
        let dileveryCharges = 0.0
        products.forEach { product in
            subTotal += ((product.price ?? 0) + (product.addons?.first?.price ?? 0)) * (Double(product.selectedQuantity ?? 0))
        }
        let total = subTotal + discount + dileveryCharges
        
        paymentRequest.paymentSummaryItems = [PKPaymentSummaryItem(label: "Pickey order", amount: NSDecimalNumber(floatLiteral: total))]
        if let controller = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest) {
            controller.delegate = self
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        self.paymentToken = payment.token.transactionIdentifier
        completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
    }
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion:  {
            self.placeOrder()
        })
    }
}
