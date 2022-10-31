//
//  CartCategoryView.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 23/06/2022.
//

import UIKit

class CartCategoryView: UIView {
    
    var product: Product? {
        didSet {
            guard let product else { return }
            self.titleLabel.text = product.name
            self.priceLabel.text = "$\(product.price ?? 0)"
        }
    }
    
    lazy var containerView: HorizontalGradientView = {
        let view = HorizontalGradientView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.cornerRadius = 10
        view.borderColor = UIColor(named: "shadowColor")
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "SM"
        view.textColor = .black
        view.textAlignment = .center
        view.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        return view
    }()
    
    lazy var priceLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "$7.99"
        view.textColor = .black
        view.textAlignment = .center
        view.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLayout() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        
        self.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            containerView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5),
            containerView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5)
        ])
        
        containerView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 6),
            titleLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 12),
            titleLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -12)
        ])
        
        containerView.addSubview(priceLabel)
        NSLayoutConstraint.activate([
            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0),
            priceLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor),
            priceLabel.rightAnchor.constraint(equalTo: titleLabel.rightAnchor)
        ])
    }
    
    var isSelected: Bool = false {
        didSet {
            if isSelected {
                self.containerView.borderWidth = 0
                self.containerView.backgroundColor = .white
                self.titleLabel.textColor = .black
                self.priceLabel.textColor = .black
                self.containerView.gradient.isHidden = false
            } else {
                self.containerView.borderWidth = 1
                self.containerView.backgroundColor = .black
                self.titleLabel.textColor = .white
                self.priceLabel.textColor = .white
                self.containerView.gradient.isHidden = true
            }
        }
    }
}
