//
//  CheckoutViewController.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 17/06/2022.
//

import UIKit

class CheckoutViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    @IBOutlet var textView : UITextView!
    var placeholderLabel : UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CartCell", bundle: .main), forCellReuseIdentifier: "cartCell")
        tableView.register(UINib(nibName: "InformationCell", bundle: .main), forCellReuseIdentifier: "informationCell")
        tableView.register(UINib(nibName: "PaymentTypeCell", bundle: .main), forCellReuseIdentifier: "paymentTypeCell")
        tableView.register(UINib(nibName: "BillingDetailsCell", bundle: .main), forCellReuseIdentifier: "billingDetailsCell")
        tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        textViewPlaceholder()
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
            headline.text = "Your Items"
        case 1:
            headline.text = "Your Information"
        case 2:
            headline.text = "Payment Details"
        case 3:
            headline.text = "Billing Summary"
        default:
            break
        }
        headline.font = UIFont(name: "Cocogoose-light", size: 20)
        headline.textColor = .white
        view.addArrangedSubview(headline)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1, 2, 3:
            return 1
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return cartCell(tableView, cellForRowAt: indexPath)
        case 1:
            return infoCell(tableView, cellForRowAt: indexPath)
        case 2:
            return paymentTypeCell(tableView, cellForRowAt: indexPath)
        case 3:
            return billingDetailsCell(tableView, cellForRowAt: indexPath)
        default:
            return UITableViewCell()
        }
    }
    
    func cartCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cartCell", for: indexPath) as! CartCell
        return cell
    }
    
    func infoCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "informationCell", for: indexPath) as! InformationCell
        return cell
    }
    
    func paymentTypeCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "paymentTypeCell", for: indexPath) as! PaymentTypeCell
        return cell
    }
    
    func billingDetailsCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "billingDetailsCell", for: indexPath) as! BillingDetailsCell
        return cell
    }
    
}

extension CheckoutViewController : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
}
