//
//  OrderDetailViewController.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 14/03/2023.
//

import UIKit

class OrderDetailViewController: UIViewController {
    
    @IBOutlet weak var orderImage: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var orderNum: UILabel!
    @IBOutlet weak var orderAmount: UILabel!
    @IBOutlet weak var orderType: UILabel!
    @IBOutlet weak var orderDate: UILabel!
    @IBOutlet weak var deliveryAddress: UILabel!
    @IBOutlet weak var deliveryStatus: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    @IBOutlet weak var reorderButtonView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var order: Order!

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib(nibName: "OrderedItemsCell", bundle: .main), forCellWithReuseIdentifier: "OrderedItemsCell")
        tableView.register(UINib(nibName: "OrderSummaryCell", bundle: .main), forCellReuseIdentifier: "OrderSummaryCell")
        
        setLayout()
    }
    
    func setLayout() {
        
        collectionView.dataSource = self
        collectionView.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: (window?.safeAreaInsets.bottom ?? 0) + 60, right: 0)
        
        orderImage.kf.setImage(with: URL(string: order.items?.first?.product?.images?.first?.path ?? ""))
        orderNum.text = "Order# " + String(order.id ?? 0)
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd,yyyy - hh:mmaa"
        
        if let date = dateFormatterGet.date(from: order.deliveryDate ?? "") {
            orderDate.text = dateFormatterPrint.string(from: date)
        } else {
            orderDate.text = ""
        }
        
        deliveryStatus.text = order.statusInText
        orderType.text = order.paymentMethodInText
        orderAmount.text = String(format: "$%.2f", order.totalPrice ?? 0)
        deliveryAddress.text = order.location?.address ?? "No Address"
        addressLabel.text = order.location?.address ?? "No Address"
        
        if order.statusInText != "Pending" {
            self.reorderButtonView.isHidden = false
        } else {
            self.reorderButtonView.isHidden = true
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(reOrder))
        reorderButtonView.addGestureRecognizer(tap)
        
        collectionView.reloadData()
        tableView.reloadData()
    }
    
    override func viewWillLayoutSubviews() {
           self.tableHeight.constant = self.tableView.contentSize.height
       }
    
    @IBAction func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func reOrder() {
        UserDefaults.standard[.cart] = []
        var storedCart = UserDefaults.standard[.cart] ?? []
        order.items?.forEach({ item in
            guard let product = item.product else {return}
            var addons: [Product]?
            if let prodAddons = item.addons?.first?.product {
                addons?.append(Product(id: prodAddons.id, name: prodAddons.name, shortDescription: prodAddons.shortDescription, longDescription: prodAddons.longDescription, price: Double(prodAddons.price ?? "0"), priceInPoints: prodAddons.priceInPoints, sku: prodAddons.sku, type: prodAddons.type, isTaxable: prodAddons.isTaxable, selectedQuantity: item.quantity, addons: nil, images: prodAddons.images, categories: prodAddons.categories))
            }
            
            let newItem = Product(id: product.id, name: product.name, shortDescription: product.shortDescription, longDescription: product.longDescription, price: Double(product.price ?? "0"), priceInPoints: product.priceInPoints, sku: product.sku, type: product.type, isTaxable: product.isTaxable, selectedQuantity: item.quantity, addons: addons, images: product.images, categories: product.categories)
            storedCart.append(newItem)
        })
        UserDefaults.standard[.cart] = storedCart
        if let controller = UIStoryboard(name: "Tabs", bundle: .main).instantiateViewController(withIdentifier: "CartViewController") as? CartViewController {
            controller.tabHomeDelegate = self
            let navigationController = UINavigationController(rootViewController: controller)
            navigationController.modalTransitionStyle = .coverVertical
            navigationController.modalPresentationStyle = .fullScreen
            navigationController.isNavigationBarHidden = true
            self.present(navigationController, animated: true)
        }
    }
}


extension OrderDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (order.items?.count ?? 0) + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderSummaryCell", for: indexPath) as! OrderSummaryCell
        if indexPath.row == order.items?.count {
            cell.nameLabel.text = "Total"
            cell.priceLabel.text = "$ " + String(order.totalPrice ?? 0)
        } else {
            cell.nameLabel.text = String(order.items?[indexPath.row].quantity ?? 0) + " x " + (order.items?[indexPath.row].productName ?? "")
            cell.priceLabel.text = "$ " + String(order.items?[indexPath.row].totalPrice ?? 0)
        }
        return cell
    }
}


extension OrderDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return order.items?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OrderedItemsCell", for: indexPath) as! OrderedItemsCell
        let item = order.items?[indexPath.item]
        cell.productImage.kf.setImage(with: URL(string: item?.product?.images?.first?.path ?? ""))
        cell.nameLabel.text = item?.productName
        cell.priceLabel.text = "$" + String(item?.totalPrice ?? 0)
        cell.originalPriceView.isHidden = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 180, height: 240)
    }
}

extension OrderDetailViewController: TabHomeDelegate {
    func moveToHome() {
        if let tab = self.navigationController?.viewControllers.first(where: {$0 is UITabBarController}) as? UITabBarController {
            tab.selectedIndex = 0
        }
        self.navigationController?.popViewController(animated: true)
    }
}
