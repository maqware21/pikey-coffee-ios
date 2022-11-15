//
//  CartViewController.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 11/06/2022.
//

import UIKit

protocol CartDelegate: AnyObject {
    func loadProducts()
}

class CartViewController: TabItemViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var checkOutView: UIView!
    
    lazy var emptyView: CartEmptyView = {
        let view = CartEmptyView(frame: .zero)
        return view
    }()
    var products = [Product]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset.bottom = 64
        tableView.register(UINib(nibName: "CartCell", bundle: .main), forCellReuseIdentifier: "cartCell")
        setLayout()
        reload()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(onClickCheckout))
        checkOutView.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }

    @IBAction func onClickBack() {
        self.dismiss(animated: true)
    }
    
    func setLayout() {
        self.view.addSubview(emptyView)
        NSLayoutConstraint.activate([
            emptyView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            emptyView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            emptyView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 32),
            emptyView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -32)
        ])
        
        emptyView.menuButton.addAction(UIAction(handler: { _ in
            self.onClickBack()
        }), for: .touchUpInside)
    }
    
    @objc func onClickCheckout() {
        if let controller = UIStoryboard(name: "Cart", bundle: .main).instantiateViewController(withIdentifier: "CheckoutViewController") as? CheckoutViewController {
            controller.delegate = self
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func reload() {
        products = UserDefaults.standard[.cart] ?? []
        if products.isEmpty {
            self.emptyView.isHidden = false
            self.checkOutView.isHidden = true
            self.tableView.reloadData()
        } else {
            self.emptyView.isHidden = true
            self.checkOutView.isHidden = false
            self.tableView.reloadData()
        }
    }
    
}


extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return products.isEmpty ? 0 : 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 4
        view.backgroundColor = .black
        view.layoutMargins = UIEdgeInsets(top: 8, left: 16, bottom: 16, right: 0)
        view.isLayoutMarginsRelativeArrangement = true
        
        let headline = UILabel()
        headline.text = "Your Items"
        headline.font = UIFont.systemFont(ofSize: 24)
        headline.textColor = .white
        
        let subline = UILabel()
        subline.text = "Pikey Coffee Decatur Blvd South"
        subline.font = UIFont.systemFont(ofSize: 22)
        subline.textColor = UIColor(named: "coffeeGray")
        
        view.addArrangedSubview(headline)
        view.addArrangedSubview(subline)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cartCell", for: indexPath) as! CartCell
        cell.product = products[indexPath.row]
        cell.quantityCallback = {[weak self] quantity in
            self?.products[indexPath.row].selectedQuantity = quantity
            UserDefaults.standard[.cart] = self?.products
            self?.reload()
        }
        cell.cartRemoveCallback = {[weak self] in
            self?.products.remove(at: indexPath.row)
            UserDefaults.standard[.cart] = self?.products
            self?.reload()
        }
        return cell
    }
}

extension CartViewController: CartDelegate {
    func loadProducts() {
        self.reload()
    }
}
