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
    private let viewModel = ProductViewModel()
    
    
    var categories: [Category]!
    var productData: ProductData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let categories {
            let names = categories.map({ $0.name ?? "" })
            segmentView.items = names
        }
        segmentView.addTarget(self, action: #selector(segmentValueChanged), for: .valueChanged)
        collectionView.register(UINib(nibName: "ProductCell", bundle: .main), forCellWithReuseIdentifier: "ProductCell")
        collectionView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        collectionView.dataSource = self
        collectionView.delegate = self
        viewModel.delegate = self
        fetchProducts(id: categories[segmentView.selectedIndex].id ?? 0)
        
        let storedCart = UserDefaults.standard[.cart] ?? []
        cartCounterView.isHidden = storedCart.isEmpty
        cartCounterLabel.text = "\(storedCart.count)"
        
        // Do any additional setup after loading the view.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func segmentValueChanged() {
        fetchProducts(id: categories[segmentView.selectedIndex].id ?? 0)
    }
    
    func fetchProducts(id: Int, page: Int = 1) {
        self.productData = nil
        self.collectionView.reloadData()
        self.showLoader()
        viewModel.getProducts(with: id, for: page)
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
            view.delegate = self
            let sheet = PickeySheet(view: view)
            self.present(sheet, animated: true)
        }), for: .touchUpInside)
        
        if (productData?.data?.count ?? 0) - indexPath.row == ProductConstants.perPageCount/2 {
            self.fetchProducts(id: categories[segmentView.selectedIndex].id ?? 0,
                               page: (productData?.pagination?.currentPage ?? 0) + 1)
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
        storedCart.append(item)
        UserDefaults.standard[.cart] = storedCart
        cartCounterView.isHidden = storedCart.isEmpty
        cartCounterLabel.text = "\(storedCart.count)"
    }
}
