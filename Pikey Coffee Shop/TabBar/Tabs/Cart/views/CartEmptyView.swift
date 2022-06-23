//
//  CartEmptyView.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 13/06/2022.
//

import UIKit

class CartEmptyView: UIView {
    
    lazy var dottedView: DashedView = {
       let view = DashedView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.dashColor = .white
        view.dashWidth = 2
        view.dashLength = 8
        view.betweenDashesSpace = 4
        view.cornerRadius = 80
        view.backgroundColor = .black
        return view
    }()
    
    lazy var cartIcon: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "cartIcon")?.withRenderingMode(.alwaysTemplate)
        view.tintColor = .white
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Your cart is empty!"
        label.font = UIFont(name: "Cocogoose", size: 20)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Looks like you have not added anything to your cart yet"
        label.font = UIFont(name: "cocogoose-light", size: 18)
        label.textColor = UIColor(hex: "999999")
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    lazy var buttonContainer: UIView = {
        let view = HorizontalGradientView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.cornerRadius = 25
        return view
    }()
    
    lazy var menuButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Back to Main Menu", for: .normal)
        button.titleLabel?.font = UIFont(name: "cocogoose-light", size: 18)
        button.setTitleColor(UIColor.black, for: .normal)
        return button
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
        
        self.addSubview(dottedView)
        NSLayoutConstraint.activate([
            dottedView.topAnchor.constraint(equalTo: self.topAnchor),
            dottedView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            dottedView.widthAnchor.constraint(equalToConstant: 160),
            dottedView.heightAnchor.constraint(equalToConstant: 160)
        ])
        
        dottedView.addSubview(cartIcon)
        NSLayoutConstraint.activate([
            cartIcon.centerXAnchor.constraint(equalTo: dottedView.centerXAnchor, constant: 0),
            cartIcon.centerYAnchor.constraint(equalTo: dottedView.centerYAnchor, constant: 0),
            cartIcon.widthAnchor.constraint(equalToConstant: 80),
            cartIcon.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        self.addSubview(emptyLabel)
        NSLayoutConstraint.activate([
            emptyLabel.topAnchor.constraint(equalTo: dottedView.bottomAnchor, constant: 48),
            emptyLabel.centerXAnchor.constraint(equalTo: dottedView.centerXAnchor)
        ])
        
        self.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: emptyLabel.bottomAnchor, constant: 16),
            descriptionLabel.centerXAnchor.constraint(equalTo: emptyLabel.centerXAnchor),
            descriptionLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
            descriptionLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0)
        ])
        
        self.addSubview(buttonContainer)
        NSLayoutConstraint.activate([
            buttonContainer.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 32),
            buttonContainer.centerXAnchor.constraint(equalTo: descriptionLabel.centerXAnchor),
            buttonContainer.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            buttonContainer.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
            buttonContainer.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            buttonContainer.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        buttonContainer.addSubview(menuButton)
        NSLayoutConstraint.activate([
            menuButton.topAnchor.constraint(equalTo: buttonContainer.topAnchor),
            menuButton.leftAnchor.constraint(equalTo: buttonContainer.leftAnchor),
            menuButton.rightAnchor.constraint(equalTo: buttonContainer.rightAnchor),
            menuButton.bottomAnchor.constraint(equalTo: buttonContainer.bottomAnchor)
        ])
    }
}
