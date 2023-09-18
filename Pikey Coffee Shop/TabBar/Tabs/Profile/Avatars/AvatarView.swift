//
//  AvatarView.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 15/09/2023.
//

import UIKit

protocol AvatarUpdated: AnyObject {
    func onAvatarUpdate()
}

class AvatarView: UIView {
    
    weak var delegate: AvatarUpdated?
    
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
        view.text = "Choose Avatar"
        view.textColor = .white
        view.textAlignment = .center
        view.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return view
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
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
        label.text = "Update"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()
    
    var selectedProfileImage = UserDefaults.standard[.selectedPic] == 0 ? 1 : UserDefaults.standard[.selectedPic]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        collectionView.register(UINib(nibName: "AvatarCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "AvatarCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        self.setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLayout() {
        self.backgroundColor = .black
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
            titleLabel.leftAnchor.constraint(equalTo: self.containerView.leftAnchor, constant: 16),
            titleLabel.rightAnchor.constraint(equalTo: self.containerView.rightAnchor, constant: -16)
        ])
        
        self.containerView.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 16),
            collectionView.leftAnchor.constraint(equalTo: self.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: self.rightAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 220)
        ])
        
        self.containerView.addSubview(confirmButton)
        NSLayoutConstraint.activate([
            confirmButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 32),
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
        
        let yesTap = UITapGestureRecognizer(target: self, action: #selector(updatePic))
        confirmButton.addGestureRecognizer(yesTap)
    }
    
    @objc func updatePic() {
        delegate?.onAvatarUpdate()
        self.parentViewController?.dismiss(animated: true)
    }
}

extension AvatarView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AvatarCollectionViewCell", for: indexPath) as! AvatarCollectionViewCell
        cell.avatarImageView.image = UIImage(named: "avatar \(indexPath.item + 1)")
        cell.checkImage.isHidden = !(selectedProfileImage == indexPath.item + 1)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedProfileImage = indexPath.item + 1
        UserDefaults.standard[.selectedPic] = selectedProfileImage
        collectionView.reloadData()
    }
}

