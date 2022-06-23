//
//  CartViewController.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 11/06/2022.
//

import UIKit

class CartViewController: TabItemViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var checkOutView: UIView!
    static var count = 1
    
    lazy var emptyView: CartEmptyView = {
        let view = CartEmptyView(frame: .zero)
        return view
    }()
    
    var sections = 0
    var rows = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CartViewController.count += 1
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset.bottom = 64
        tableView.register(UINib(nibName: "CartCell", bundle: .main), forCellReuseIdentifier: "cartCell")
        setLayout()
        
        if CartViewController.count % 2 != 0 {
            self.emptyView.isHidden = false
            self.rows = 0
            self.sections = 0
            self.checkOutView.isHidden = true
            self.tableView.reloadData()
        } else {
            self.emptyView.isHidden = true
            self.rows = 5
            self.sections = 1
            self.checkOutView.isHidden = false
            self.tableView.reloadData()
        }
        
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
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}


extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections
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
        headline.font = UIFont(name: "Cocogoose-light", size: 20)
        headline.textColor = .white
        
        let subline = UILabel()
        subline.text = "Pikey Coffee Decatur Blvd South"
        subline.font = UIFont(name: "Cocogoose-light", size: 18)
        subline.textColor = UIColor(named: "coffeeGray")
        
        view.addArrangedSubview(headline)
        view.addArrangedSubview(subline)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cartCell", for: indexPath) as! CartCell
        return cell
    }
}
