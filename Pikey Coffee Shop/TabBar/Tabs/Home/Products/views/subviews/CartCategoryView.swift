//
//  CartCategoryView.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 23/06/2022.
//

import UIKit

typealias CartCategoryCallback = ((_: Int) -> Void)

class CartCategoryView: UIView {
    
    var product: Product? {
        didSet {
            guard let product else { return }
            self.titleLabel.text = product.name
            if product.price ?? 0 > 0 {
                let price = String(format: "%.2f", product.price ?? 0)
                self.priceLabel.isHidden = false
                self.priceLabel.text = "$\(price)"
            } else {
                self.priceLabel.isHidden = true
            }
        }
    }
    
    var onSelected: CartCategoryCallback?
    
    lazy var containerView: HorizontalGradientView = {
        let view = HorizontalGradientView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.cornerRadius = 10
        view.borderColor = UIColor(named: "shadowColor")
        return view
    }()
    
    lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.spacing = 4
        view.distribution = .fillEqually
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
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(categorySelected(_:)))
        self.addGestureRecognizer(tap)
        
        self.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            containerView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5),
            containerView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5)
        ])
        
        self.containerView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 6),
            stackView.leftAnchor.constraint(equalTo: self.containerView.leftAnchor, constant: 12),
            stackView.rightAnchor.constraint(equalTo: self.containerView.rightAnchor, constant: -12),
            stackView.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: -6)
        ])
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(priceLabel)
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
    
    @objc func categorySelected(_ gesture: UIGestureRecognizer) {
        if !isSelected {
            isSelected.toggle()
            onSelected?(self.tag)
        }
    }
}
