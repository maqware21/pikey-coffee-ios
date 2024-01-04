//
//  PreCheckoutViewController.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 04/06/2023.
//

import UIKit

class PreCheckoutViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    
    weak var delegate: CartDelegate?
    let viewModel = CheckOutViewModel()
    var products = [Product]()
    var address = UserDefaults.standard[.selectedAddress]
    var selectedType: OrderTypeState = .future
    
    override func viewDidLoad() {
        super.viewDidLoad()
        products = UserDefaults.standard[.cart] ?? []
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CartCell", bundle: .main), forCellReuseIdentifier: "cartCell")
        tableView.register(UINib(nibName: "InformationCell", bundle: .main), forCellReuseIdentifier: "informationCell")
        tableView.register(UINib(nibName: "BillingDetailsCell", bundle: .main), forCellReuseIdentifier: "billingDetailsCell")
        tableView.register(UINib(nibName: "OrderPickupTypeCell", bundle: .main), forCellReuseIdentifier: "OrderPickupTypeCell")
        tableView.register(UINib(nibName: "DatePickerCell", bundle: .main), forCellReuseIdentifier: "DatePickerCell")
        tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        // Do any additional setup after loading the view.
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
    
    @IBAction func onClickProceedToCheckout() {
        if let controller = UIStoryboard(name: "Cart", bundle: .main).instantiateViewController(withIdentifier: "CheckoutViewController") as? CheckoutViewController {
            controller.delegate = delegate
            controller.selectedType = selectedType
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}

extension PreCheckoutViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        switch selectedType {
        case .future:
            return 5
        default:
            return 4
        }
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
            headline.text = "Order Pickup type"
        case 3:
            headline.text = selectedType == .future ? "Pickup Date" : "Billing Summary"
        case 4:
            headline.text = "Billing Summary"
        default:
            break
        }
        headline.font = UIFont.systemFont(ofSize: 24)
        headline.textColor = .white
        view.addArrangedSubview(headline)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return products.count
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
            return orderTypeCell(tableView, cellForRowAt: indexPath)
        case 3:
            if selectedType == .future {
                return pickupDateCell(tableView, cellForRowAt: indexPath)
            } else {
                return billingDetailsCell(tableView, cellForRowAt: indexPath)
            }
        case 4:
            return billingDetailsCell(tableView, cellForRowAt: indexPath)
        default:
            return UITableViewCell()
        }
    }
    
    func cartCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cartCell", for: indexPath) as! CartCell
        cell.product = products[indexPath.row]
        cell.quantityCallback = {[weak self] quantity in
            self?.products[indexPath.row].selectedQuantity = quantity
            UserDefaults.standard[.cart] = self?.products
            tableView.reloadData()
        }
        cell.cartRemoveCallback = {[weak self] in
            self?.products.remove(at: indexPath.row)
            UserDefaults.standard[.cart] = self?.products
            self?.delegate?.loadProducts()
            if self?.products.isEmpty ?? [].isEmpty { self?.navigationController?.popViewController(animated: true) }
            tableView.reloadData()
        }
        return cell
    }
    
    func infoCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "informationCell", for: indexPath) as! InformationCell
        cell.address = address
        cell.selectedType = self.selectedType
        cell.callback = {[weak self] in
            self?.moveToMyAddresses()
        }
        return cell
    }
    
    func moveToMyAddresses() {
        if let vc = UIStoryboard(name: "Profile", bundle: .main).instantiateViewController(withIdentifier: "MyAddressesViewController") as? MyAddressesViewController {
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func orderTypeCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderPickupTypeCell", for: indexPath) as! OrderPickupTypeCell
        cell.stateSelected = {[weak self] state in
            self?.selectedType = state
            self?.tableView.reloadData()
        }
        return cell
    }
    
    func billingDetailsCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "billingDetailsCell", for: indexPath) as! BillingDetailsCell
        cell.pickupType = selectedType
        cell.products = products
        return cell
    }
    
    func pickupDateCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DatePickerCell", for: indexPath) as! DatePickerCell
        return cell
    }
    
}

extension PreCheckoutViewController: CheckoutAddressUpdateDelegate {
    func addressUpdated() {
        self.address = UserDefaults.standard[.selectedAddress]
        tableView.reloadData()
    }
}
