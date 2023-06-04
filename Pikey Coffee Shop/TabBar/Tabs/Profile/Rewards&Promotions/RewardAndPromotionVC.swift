//
//  RewardAndPromotionVC.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 27/05/2023.
//

import UIKit

class RewardAndPromotionVC: EditProfileBaseViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib(nibName: "RewardAndPromotionCell", bundle: .main), forCellWithReuseIdentifier: "RewardAndPromotionCell")
        collectionView.register(UINib(nibName: "RewardsHeaderCell", bundle: .main), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "RewardsHeaderCell")
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    @IBAction func onclickBack() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension RewardAndPromotionVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? 4 : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RewardAndPromotionCell", for: indexPath) as! RewardAndPromotionCell
        if indexPath.section == 0 {
            cell.imageView.image = UIImage(named: "reward\(indexPath.item + 1)")
        } else {
            cell.imageView.image = UIImage(named: "reward5")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return indexPath.section == 0 ? CGSize(width: self.collectionView.frame.width/2 - 10, height: 250) : CGSize(width: self.collectionView.frame.width, height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "RewardsHeaderCell", for: indexPath)
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            return headerView
        default:
            assert(false, "Unexpected element kind")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return section == 0 ? CGSize(width: self.collectionView.frame.width, height: 0) : CGSize(width: self.collectionView.frame.width, height: 56)
    }
}
