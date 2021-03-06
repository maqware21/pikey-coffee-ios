//
//  DeliveryViewController.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 17/06/2022.
//

import UIKit

class DeliveryView: UIView {
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var grabberView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hex: "111111")
        view.cornerRadius = 2.5
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Deliver to"
        view.textColor = .white
        view.font = UIFont(name: "Cocogoose", size: 20)
        return view
    }()
    
    lazy var addAddressButton: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.borderWidth = 1
        view.borderColor = UIColor(named: "shadowColor")
        view.cornerRadius = 15
        return view
    }()
    
    lazy var addAddressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "+ Add Address"
        label.textColor = .white
        label.font = UIFont(name: "Cocogoose-light", size: 14)
        label.textAlignment = .center
        return label
    }()
    
    lazy var fieldContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.cornerRadius = 25
        view.shadowColor = UIColor(named: "shadowColor")
        view.shadowOffset = CGSize(width: 0, height: -3)
        view.shadowOpacity = 0.7
        view.shadowRadius = 16
        view.masksToBounds = false
        return view
    }()
    
    lazy var currentLocationfield: IconTextField = {
        let view = IconTextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.iconSize = CGSize(width: 32, height: 32)
        view.icon = UIImage(named: "locateIcon")
        view.font = UIFont(name: "Cocogoose-light", size: 14)
        view.placeholder = "Use Current Location"
        view.textColor = .white
        view.placeholderColor = UIColor(hex: "888888")
        return view
    }()
    
    lazy var adddressLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Delivery Addresses"
        view.textColor = .white
        view.font = UIFont(name: "Cocogoose", size: 20)
        return view
    }()
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.separatorStyle = .none
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        tableView.register(UINib(nibName: "MyAddressCell", bundle: .main), forCellReuseIdentifier: "myAddressCell")
        tableView.delegate = self
        tableView.dataSource = self
        self.setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLayout() {
        
        self.backgroundColor = .black
        
        self.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.topAnchor),
            containerView.leftAnchor.constraint(equalTo: self.leftAnchor),
            containerView.rightAnchor.constraint(equalTo: self.rightAnchor),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        self.containerView.addSubview(grabberView)
        NSLayoutConstraint.activate([
            grabberView.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 16),
            grabberView.centerXAnchor.constraint(equalTo: self.containerView.centerXAnchor),
            grabberView.widthAnchor.constraint(equalToConstant: 150),
            grabberView.heightAnchor.constraint(equalToConstant: 5)
        ])
        
        self.containerView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.grabberView.bottomAnchor, constant: 24),
            titleLabel.leftAnchor.constraint(equalTo: self.containerView.leftAnchor, constant: 16)
        ])
        
        self.containerView.addSubview(addAddressButton)
        NSLayoutConstraint.activate([
            addAddressButton.centerYAnchor.constraint(equalTo: self.titleLabel.centerYAnchor, constant: 0),
            addAddressButton.rightAnchor.constraint(equalTo: self.containerView.rightAnchor, constant: -16),
            addAddressButton.heightAnchor.constraint(equalToConstant: 30),
            addAddressButton.widthAnchor.constraint(equalToConstant: 130),
            addAddressButton.leftAnchor.constraint(greaterThanOrEqualTo: self.titleLabel.rightAnchor, constant: 16)
        ])
        
        self.addAddressButton.addSubview(addAddressLabel)
        NSLayoutConstraint.activate([
            addAddressLabel.topAnchor.constraint(equalTo: self.addAddressButton.topAnchor),
            addAddressLabel.leftAnchor.constraint(equalTo: self.addAddressButton.leftAnchor),
            addAddressLabel.rightAnchor.constraint(equalTo: self.addAddressButton.rightAnchor),
            addAddressLabel.bottomAnchor.constraint(equalTo: self.addAddressButton.bottomAnchor)
        ])
        
        self.containerView.addSubview(fieldContainer)
        NSLayoutConstraint.activate([
            fieldContainer.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 32),
            fieldContainer.leftAnchor.constraint(equalTo: self.titleLabel.leftAnchor, constant: 0),
            fieldContainer.rightAnchor.constraint(equalTo: self.addAddressButton.rightAnchor),
            fieldContainer.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        self.fieldContainer.addSubview(currentLocationfield)
        NSLayoutConstraint.activate([
            currentLocationfield.topAnchor.constraint(equalTo: self.fieldContainer.topAnchor, constant: 5),
            currentLocationfield.leftAnchor.constraint(equalTo: self.fieldContainer.leftAnchor, constant: 5),
            currentLocationfield.rightAnchor.constraint(equalTo: self.fieldContainer.rightAnchor, constant: -5),
            currentLocationfield.bottomAnchor.constraint(equalTo: self.fieldContainer.bottomAnchor, constant: -5)
        ])
        
        self.containerView.addSubview(adddressLabel)
        NSLayoutConstraint.activate([
            adddressLabel.topAnchor.constraint(equalTo: self.currentLocationfield.bottomAnchor, constant: 24),
            adddressLabel.leftAnchor.constraint(equalTo: self.titleLabel.leftAnchor, constant: 0)
        ])
        
        self.containerView.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.adddressLabel.bottomAnchor, constant: 16),
            tableView.leftAnchor.constraint(equalTo: self.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: self.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: -32),
            tableView.heightAnchor.constraint(equalToConstant: 250)
        ])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(addLocationClicked))
        addAddressButton.addGestureRecognizer(tap)
    }
    
    @objc func addLocationClicked() {
        let controller = AddAddressView(frame: .zero)
        let vc = PickeySheet(view: controller, withAnimation: false)
        self.parentViewController?.navigationController?.pushViewController(vc, animated: true)
    }
}

extension DeliveryView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myAddressCell", for: indexPath) as! MyAddressCell
        if indexPath.row == 0 {
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        }
        return cell
    }
}
