//
//  DeliveryViewController.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 17/06/2022.
//

import UIKit

class DeliveryView: UIView {
    
    var addresses: AddressList?
    var profileViewModel = ProfileViewModel()
    
    
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
        view.font = UIFont.systemFont(ofSize: 24, weight: .bold)
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
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        return label
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
        profileViewModel.delegate = self
        fetchAddresses(page: 1)
        
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
        
        self.containerView.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.addAddressLabel.bottomAnchor, constant: 16),
            tableView.leftAnchor.constraint(equalTo: self.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: self.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: -32),
            tableView.heightAnchor.constraint(equalToConstant: 250)
        ])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(addLocationClicked))
        addAddressButton.addGestureRecognizer(tap)
    }
    
    @objc func addLocationClicked() {
        if let vc = UIStoryboard(name: "Profile", bundle: .main).instantiateViewController(withIdentifier: "AddLocationViewController") as? AddLocationViewController {
            vc.delegate = self
            self.parentViewController?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func fetchAddresses(page: Int) {
        profileViewModel.getAddressList(for: page)
    }
}

extension DeliveryView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addresses?.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myAddressCell", for: indexPath) as! MyAddressCell
        let address = addresses?.data?[indexPath.row]
        cell.address = address
        if address?.isPrimary == 1 {
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        }
        if (addresses?.data?.count ?? 0) - indexPath.row == AddressConstant.perPageCount/2 {
            self.fetchAddresses(page: (addresses?.pagination?.currentPage ?? 0) + 1)
        }
        
        return cell
    }
}

extension DeliveryView: AddLocationDelegate {
    func locationAdded() {
        profileViewModel.getAddressList(for: 1)
    }
}

extension DeliveryView: ProfileDelegate {
    func addressListUpdated(addresses: AddressList?) {
        DispatchQueue.main.async {
            if addresses?.pagination?.currentPage != 1 {
                self.addresses?.data?.append(contentsOf: addresses?.data ?? [])
                self.addresses?.pagination = addresses?.pagination
            } else {
                self.addresses = addresses
            }
            UserDefaults.standard[.addresses] = self.addresses
            UserDefaults.standard[.selectedAddress] = self.addresses?.data?.first
            self.tableView.reloadData()
        }
    }
}
