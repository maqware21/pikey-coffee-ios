//
//  GiftCardViewController.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 21/05/2023.
//

import UIKit

class GiftCardViewController: UIViewController {

    @IBOutlet weak var amountView: UIView!
    @IBOutlet weak var amountViewHeight: NSLayoutConstraint!
    @IBOutlet weak var customAmountView: UIView!
    @IBOutlet weak var amountViewBottom: NSLayoutConstraint!
    @IBOutlet weak var customAmountViewBottom: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        amountView.isHidden = true
        amountViewHeight.constant = 0
        customAmountView.isHidden = true
        amountViewBottom.priority = .required
        customAmountViewBottom.priority = .defaultHigh
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
    }
}
