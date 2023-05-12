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
        view.text = "Pickup"
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
    
    lazy var confirmButton: HorizontalGradientView = {
        let view = HorizontalGradientView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.cornerRadius = 25
        return view
    }()
    
    lazy var yesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "SHOW ALL ADDRESSES"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()
    
    lazy var loader: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.style = .medium
        view.color = .white
        return view
    }()
    
    lazy var emptyLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Add your office/home address."
        view.textColor = .white
        view.textAlignment = .center
        view.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        view.isHidden = true
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
            tableView.heightAnchor.constraint(equalToConstant: 220)
        ])
        
        self.containerView.addSubview(confirmButton)
        NSLayoutConstraint.activate([
            confirmButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 32),
            confirmButton.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 32),
            confirmButton.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -32),
            confirmButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -32),
            confirmButton.heightAnchor.constraint(equalToConstant: 48)
        ])
        
        confirmButton.addSubview(yesLabel)
        NSLayoutConstraint.activate([
            yesLabel.topAnchor.constraint(equalTo: confirmButton.topAnchor),
            yesLabel.leftAnchor.constraint(equalTo: confirmButton.leftAnchor),
            yesLabel.rightAnchor.constraint(equalTo: confirmButton.rightAnchor),
            yesLabel.bottomAnchor.constraint(equalTo: confirmButton.bottomAnchor)
        ])
        
        self.containerView.addSubview(loader)
        NSLayoutConstraint.activate([
            loader.widthAnchor.constraint(equalToConstant: 40),
            loader.heightAnchor.constraint(equalToConstant: 40),
            loader.centerXAnchor.constraint(equalTo: self.containerView.centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: self.containerView.centerYAnchor)
        ])
        
        self.containerView.addSubview(emptyLabel)
        NSLayoutConstraint.activate([
            emptyLabel.centerYAnchor.constraint(equalTo: self.containerView.centerYAnchor, constant: 0),
            emptyLabel.centerXAnchor.constraint(equalTo: self.containerView.centerXAnchor, constant: 0),
            emptyLabel.rightAnchor.constraint(equalTo: self.containerView.rightAnchor, constant: -16),
            emptyLabel.leftAnchor.constraint(equalTo: self.containerView.rightAnchor, constant: 16)
        ])
        
        let yesTap = UITapGestureRecognizer(target: self, action: #selector(showAllAddress))
        confirmButton.addGestureRecognizer(yesTap)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(addLocationClicked))
        addAddressButton.addGestureRecognizer(tap)
        
        self.loader.isHidden = false
        self.loader.startAnimating()
    }
    
    @objc func addLocationClicked() {
        if let vc = UIStoryboard(name: "Profile", bundle: .main).instantiateViewController(withIdentifier: "AddLocationViewController") as? AddLocationViewController {
            vc.delegate = self
            self.parentViewController?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func showAllAddress() {
        if let vc = UIStoryboard(name: "Profile", bundle: .main).instantiateViewController(withIdentifier: "MyAddressesViewController") as? MyAddressesViewController {
            self.parentViewController?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func fetchAddresses(page: Int) {
        profileViewModel.getAddressList(for: page)
    }
}

extension DeliveryView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = self.addresses?.data?.count {
            if count > 2 {
                return 2
            } else {
                return count
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myAddressCell", for: indexPath) as! MyAddressCell
        let address = addresses?.data?[indexPath.row]
        cell.address = address
        if (addresses?.data?.count ?? 0) - indexPath.row == AddressConstant.perPageCount/2 && addresses?.pagination?.totalPages ?? 0 > addresses?.pagination?.currentPage ?? 0 {
            self.fetchAddresses(page: (addresses?.pagination?.currentPage ?? 0) + 1)
        }
        
        cell.idCallback = {[weak self] id, type in
            switch type {
            case .edit:
                print("edit")
            case .delete:
                guard let id else {return}
                if self?.addresses?.data?.count ?? 0 > 1 {
                    self?.parentViewController?.showLoader()
                    self?.profileViewModel.deleteAddress(with: id)
                } else {
                    self?.parentViewController?.view?.displayNotice(with: "Last address cannot be removed")
                }
            }
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
            self.loader.stopAnimating()
            self.loader.isHidden = true
            if addresses?.pagination?.currentPage != 1 {
                self.addresses?.data?.append(contentsOf: addresses?.data ?? [])
                self.addresses?.pagination = addresses?.pagination
            } else {
                self.addresses = addresses
            }
            UserDefaults.standard[.addresses] = self.addresses
            if UserDefaults.standard[.selectedAddress] == nil {
                UserDefaults.standard[.selectedAddress] = self.addresses?.data?.first
            }
            if let index = self.addresses?.data?.firstIndex(where: { $0.id == UserDefaults.standard[.selectedAddress]?.id }) {
                self.addresses?.data?.swapAt(0, index)
            }
            self.emptyLabel.isHidden = (self.addresses?.data?.count ?? 0) > 0
            self.tableView.reloadData()
        }
    }
    
    func addressDeleted(_ message: String?, id: Int) {
        DispatchQueue.main.async {
            self.parentViewController?.removeLoader()
            guard let message else { return }
            if let address = self.addresses?.data?.first(where: { $0.id == id}) {
                self.addresses?.data?.removeAll(where: { $0.id == id})
                if UserDefaults.standard[.selectedAddress]?.id == address.id {
                    UserDefaults.standard[.selectedAddress] = self.addresses?.data?.first
                }
            }
            self.emptyLabel.isHidden = (self.addresses?.data?.count ?? 0) > 0
            self.tableView.reloadData()
            self.parentViewController?.view?.displayNotice(with: message)
        }
    }
}
