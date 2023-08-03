//
//  ProductViewController.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 23/06/2022.
//

import UIKit
import BetterSegmentedControl

class ProductViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionHeight: NSLayoutConstraint!
    @IBOutlet weak var segmentView: CollectionViewSegmentedControl!
    @IBOutlet weak var cartCounterView: UIView!
    @IBOutlet weak var cartCounterLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    private let viewModel = ProductViewModel()
    
    var forMerchandise: Bool = false
    var categories: [Category]?
    var categoryID: Int!
    var productData: ProductData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib(nibName: "ProductCell", bundle: .main), forCellWithReuseIdentifier: "ProductCell")
        collectionView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        collectionView.dataSource = self
        collectionView.delegate = self
        viewModel.delegate = self
        
        /// Segment view implementation.
//        segmentView.addTarget(self, action: #selector(segmentValueChanged), for: .valueChanged)
//        if let categories {
//            let names = categories.map({ $0.name ?? "" })
//            segmentView.items = names
//        }
        if forMerchandise {
            self.titleLabel.text = "Merchandise"
            fetchMerchandise()
        } else {
            self.titleLabel.text = "Products"
            fetchProducts(id: categoryID)
        }
        updateCartCounter()
        
        // Do any additional setup after loading the view.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func updateCartCounter() {
        let storedCart = UserDefaults.standard[.cart] ?? []
        cartCounterView.isHidden = storedCart.isEmpty
        cartCounterLabel.text = "\(storedCart.count)"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateCartCounter()
    }
    
//    @objc func segmentValueChanged() {
//        fetchProducts(id: categories?[segmentView.selectedIndex].id ?? 0)
//    }
    
    func fetchProducts(id: Int, page: Int = 1) {
        self.productData = nil
        self.collectionView.reloadData()
        self.showLoader()
        viewModel.getProducts(with: id, for: page)
    }
    
    func fetchMerchandise(page: Int = 1) {
        self.productData = nil
        self.collectionView.reloadData()
        self.showLoader()
        viewModel.getMerchandise(for: page)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if(keyPath == "contentSize"){
            if let newvalue = change?[.newKey]
            {
                let newsize  = newvalue as! CGSize
                collectionHeight.constant = newsize.height + 16
            }
        }
    }
    
    @IBAction func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onclickCart() {
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

extension ProductViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productData?.data?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCell
        let product = productData?.data?[indexPath.item]
        cell.product = product
        cell.cartButton.addAction(UIAction(handler: { _ in
            let view = AddToCartView()
            view.product = product
            view.modifiers = product?.categories?.first?.modifiers
            view.delegate = self
            let sheet = PickeySheet(view: view)
            self.present(sheet, animated: true)
        }), for: .touchUpInside)
        
        if (productData?.data?.count ?? 0) - indexPath.row == ProductConstants.perPageCount/2 && productData?.pagination?.totalPages ?? 0 > productData?.pagination?.currentPage ?? 0 {
            if forMerchandise {
                self.fetchMerchandise(page: (productData?.pagination?.currentPage ?? 0) + 1)
            } else {
                self.fetchProducts(id: categoryID,
                                   page: (productData?.pagination?.currentPage ?? 0) + 1)
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.width/2, height: 320)
    }
}


extension ProductViewController: ProductsDelegate {
    func productsUpdate(with products: ProductData?) {
        DispatchQueue.main.async {
            self.removeLoader()
            if let products {
                if products.pagination?.currentPage != 1 {
                    self.productData?.data?.append(contentsOf: products.data ?? [])
                    self.productData?.pagination = products.pagination
                } else {
                    self.productData = products
                }
            }
            self.collectionView.reloadData()
        }
    }
}

extension ProductViewController: AddToCartDelegate {
    func addToCart(_ item: Product?) {
        guard let item else {
            return
        }
        
        var storedCart = UserDefaults.standard[.cart] ?? []
        if let index = storedCart.firstIndex(where: {$0.id == item.id}),
            storedCart[index].addons?.first?.id ?? 0 == item.addons?.first?.id ?? 0 {
            storedCart[index].selectedQuantity = (item.selectedQuantity ?? 0) + (storedCart[index].selectedQuantity ?? 0)
            storedCart[index].modifiers = item.modifiers
        } else {
            storedCart.append(item)
        }
        
        UserDefaults.standard[.cart] = storedCart
        cartCounterView.isHidden = storedCart.isEmpty
        cartCounterLabel.text = "\(storedCart.count)"
    }
}

extension ProductViewController: TabHomeDelegate {
    func moveToHome() {
        self.navigationController?.popViewController(animated: true)
    }
}
