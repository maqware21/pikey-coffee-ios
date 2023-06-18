//
//  MerchandiseVC.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 28/05/2023.
//

import UIKit

class MerchandiseVC: EditProfileBaseViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var segmentView: CollectionViewSegmentedControl!
    var categories = [MerchandiseCategory]()
    var viewModel = MerchandiseViewmodel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib(nibName: "MerchandiseCell", bundle: .main), forCellWithReuseIdentifier: "MerchandiseCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        segmentView.addTarget(self, action: #selector(segmentValueChanged), for: .valueChanged)
        viewModel.delegate = self
        self.showLoader()
        viewModel.getCategories()
    }

    @objc func segmentValueChanged() {
        // to do
    }
    
    @IBAction func onClickBack() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension MerchandiseVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MerchandiseCell", for: indexPath) as! MerchandiseCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.width/2 - 10, height: 270)
    }
}

extension MerchandiseVC: MerchandiseDelegate {
    func categoriesUpdated(_ categories: [MerchandiseCategory]?) {
        DispatchQueue.main.async {
            self.removeLoader()
            self.categories = categories ?? []
            self.segmentView.items = (categories ?? []).map({ cat in
                return cat.name ?? ""
            })
        }
    }
}
