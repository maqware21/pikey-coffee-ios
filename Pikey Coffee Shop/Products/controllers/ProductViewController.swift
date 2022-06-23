//
//  ProductViewController.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 23/06/2022.
//

import UIKit
import BetterSegmentedControl

class ProductViewController: UIViewController {

    @IBOutlet weak var segmentControl: BetterSegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentControl.segments = LabelSegment.segments(withTitles: ["Coffee", "Espresso", "Tea"],
                              normalTextColor: UIColor(hex: "888888"),
                              selectedTextColor: .black)
        segmentControl.setOptions([.backgroundColor(.black),
                                    .indicatorViewBackgroundColor(.white),
                                    .cornerRadius(20.0),
                                    .animationSpringDamping(1.0)])
        
        collectionView.register(UINib(nibName: "ProductCell", bundle: .main), forCellWithReuseIdentifier: "ProductCell")
        collectionView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        collectionView.dataSource = self
        collectionView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
}

extension ProductViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCell
        cell.cartButton.addAction(UIAction(handler: { _ in
            let view = AddToCartView()
            let sheet = PickeySheet(view: view)
            self.present(sheet, animated: true)
        }), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.width/2, height: 290)
    }
}
