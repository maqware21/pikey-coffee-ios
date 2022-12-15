//
//  MyAddressesViewController.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 15/06/2022.
//

import UIKit

class MyAddressesViewController: EditProfileBaseViewController {

    @IBOutlet weak var tableView: UITableView!
    var viewModel = ProfileViewModel()
    var addressData: AddressList?
    weak var delegate: CheckoutAddressUpdateDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.viewModel.delegate = self
        tableView.register(UINib(nibName: "MyAddressCell", bundle: .main), forCellReuseIdentifier: "myAddressCell")
        fetchAddresses(page: 1)
        // Do any additional setup after loading the view.
    }
    
    func fetchAddresses(page: Int) {
        self.showLoader()
        viewModel.getAddressList(for: page)
    }

    @IBAction func onclickBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickAddAddress() {
        if let vc = UIStoryboard(name: "Profile", bundle: .main).instantiateViewController(withIdentifier: "AddLocationViewController") as? AddLocationViewController {
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}


extension MyAddressesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addressData?.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myAddressCell", for: indexPath) as! MyAddressCell
        let address = addressData?.data?[indexPath.row]
        cell.address = address
        if (addressData?.data?.count ?? 0) - indexPath.row == AddressConstant.perPageCount/2 && addressData?.pagination?.totalPages ?? 0 > addressData?.pagination?.currentPage ?? 0 {
            self.fetchAddresses(page: (addressData?.pagination?.currentPage ?? 0) + 1)
        }
        
        cell.callback = {[weak self] in
            UserDefaults.standard[.selectedAddress] = address
            self?.tableView.reloadData()
            if let delegate = self?.delegate {
                delegate.addressUpdated()
                self?.navigationController?.popViewController(animated: true)
            }
        }
        
        cell.idCallback = {[weak self] id, type in
            switch type {
            case .edit:
                print("edit")
            case .delete:
                guard let id else {return}
                if self?.addressData?.data?.count ?? 0 > 1 {
                    self?.showLoader()
                    self?.viewModel.deleteAddress(with: id)
                } else {
                    self?.view.displayNotice(with: "Last address cannot be removed")
                }
            }
        }
        
        return cell
    }

}

extension MyAddressesViewController: ProfileDelegate {
    func addressListUpdated(addresses: AddressList?) {
        DispatchQueue.main.async {
            self.removeLoader()
            if addresses?.pagination?.currentPage != 1 {
                self.addressData?.data?.append(contentsOf: addresses?.data ?? [])
                self.addressData?.pagination = addresses?.pagination
            } else {
                self.addressData = addresses
            }
            UserDefaults.standard[.addresses] = self.addressData
            if UserDefaults.standard[.selectedAddress] == nil {
                UserDefaults.standard[.selectedAddress] = self.addressData?.data?.first
            }
            self.tableView.reloadData()
        }
    }
    
    func addressDeleted(_ message: String?, id: Int) {
        DispatchQueue.main.async {
            self.removeLoader()
            guard let message else { return }
            if let address = self.addressData?.data?.first(where: { $0.id == id}) {
                self.addressData?.data?.removeAll(where: { $0.id == id})
                if UserDefaults.standard[.selectedAddress]?.id == address.id {
                    UserDefaults.standard[.selectedAddress] = self.addressData?.data?.first
                }
            }
            self.tableView.reloadData()
            self.view.displayNotice(with: message)
        }
    }
}

extension MyAddressesViewController: AddLocationDelegate {
    func locationAdded() {
        self.fetchAddresses(page: 1)
    }
}
