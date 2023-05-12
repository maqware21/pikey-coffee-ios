//
//  OrdersEmptyView.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 13/05/2023.
//

import UIKit

class OrdersEmptyView: UIView {
    
    lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "No Order"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Looks like you have no orders yet"
        label.font = UIFont.systemFont(ofSize: 22)
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
        button.titleLabel?.font = UIFont.systemFont(ofSize: 22)
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
        
        self.addSubview(emptyLabel)
        NSLayoutConstraint.activate([
            emptyLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            emptyLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
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
