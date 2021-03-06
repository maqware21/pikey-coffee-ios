//
//  OrderViewController.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 08/06/2022.
//

import UIKit

class OrderViewController: TabItemViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "OrderListCell", bundle: .main), forCellReuseIdentifier: "orderCell")
        tableView.contentInset.bottom = 48
        // Do any additional setup after loading the view.
    }

}

extension OrderViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "orderCell", for: indexPath) as! OrderListCell
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .black
        let label = UILabel()
        label.text = "Current Order"
        label.font = UIFont(name: "Cocogoose-light", size: 20)
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
        return 60
    }
    
}

extension OrderViewController: OrderCellDelegate, ConfirmationDelegate {
    func presentOnCell() {
        let controller = ConfirmationBottomSheet()
        controller.delegate = self
        controller.titleLabel.text = "Cancel Order"
        controller.messageLabel.text = "Are you sure you want to cancel the order?"
        let vc = PickeySheet(view: controller)
        self.present(vc, animated: true)
    }
    
    func confirmAction() {
        self.presentedViewController?.dismiss(animated: true)
    }
}


