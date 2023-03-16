//
//  OrderViewController.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 08/06/2022.
//

import UIKit

class OrderViewController: TabItemViewController {

    @IBOutlet weak var tableView: UITableView!
    var viewModel = OrderViewModel()
    var ordersData: OrderList?
    var itemId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        viewModel.delegate = self
        tableView.register(UINib(nibName: "OrderListCell", bundle: .main), forCellReuseIdentifier: "orderCell")
        tableView.contentInset.bottom = 48
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    
    func loadData(page: Int = 0) {
        self.showLoader()
        viewModel.getOrders(page: page)
    }

}

extension OrderViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ordersData?.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "orderCell", for: indexPath) as! OrderListCell
        cell.delegate = self
        cell.order = ordersData?.data?[indexPath.row]
        if (ordersData?.data?.count ?? 0) - indexPath.row == OrderConstants.perPageCount/2 && ordersData?.pagination?.totalPages ?? 0 > ordersData?.pagination?.currentPage ?? 0 {
            self.loadData(page: (ordersData?.pagination?.currentPage ?? 0) + 1)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .black
        let label = UILabel()
        if section == 0 {
            label.text = "Current Order"
        } else {
            label.text = "Past Order"
        }
        label.font = UIFont.systemFont(ofSize: 24)
        label.textColor = .white
        label.backgroundColor = .black
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let controller = UIStoryboard(name: "Orders", bundle: .main).instantiateViewController(withIdentifier: "OrderDetailViewController") as? OrderDetailViewController {
            controller.order = ordersData?.data?[indexPath.row]
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
}

extension OrderViewController: OrderCellDelegate, ConfirmationDelegate {
    func presentOnCell(id: Int?) {
        itemId = id
        let controller = ConfirmationBottomSheet()
        controller.delegate = self
        controller.titleLabel.text = "Cancel Order"
        controller.messageLabel.text = "Are you sure you want to cancel the order?"
        let vc = PickeySheet(view: controller)
        self.present(vc, animated: true)
    }
    
    func confirmAction() {
        self.presentedViewController?.dismiss(animated: true)
        guard let itemId else {return}
        viewModel.cancelOrders(id: itemId)
    }
}


extension OrderViewController: OrderDelegate {
    func ordersUpdated(_ orders: OrderList?) {
        DispatchQueue.main.async {
            self.removeLoader()
            if let orders {
                if orders.pagination?.currentPage != 1 {
                    self.ordersData?.data?.append(contentsOf: orders.data ?? [])
                    self.ordersData?.data?.sort(by: {$0.createdAt > $1.createdAt})
                    self.ordersData?.pagination = orders.pagination
                } else {
                    self.ordersData = orders
                    self.ordersData?.data?.sort(by: {$0.createdAt > $1.createdAt})
                }
                self.tableView.reloadData()
            }
        }
    }
    
    func orderCancelled(_ id: Int?) {
        DispatchQueue.main.async {
            self.removeLoader()
            if let id {
                if let index = self.ordersData?.data?.firstIndex(where: {$0.id == id}) {
                    self.ordersData?.data?[index].statusInText = "Cancelled"
                }
                self.tableView.reloadData()
            }
        }
    }
}
