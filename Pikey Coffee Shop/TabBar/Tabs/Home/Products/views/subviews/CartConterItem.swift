//
//  CartItemCounter.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 24/06/2022.
//

import UIKit

class CartConterItem: UIView {
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.cornerRadius = 20
        view.backgroundColor = .black
        view.shadowColor = UIColor(named: "shadowColor")
        view.shadowOffset = CGSize(width: 0, height: -3)
        view.shadowRadius = 8
        view.shadowOpacity = 0.7
        view.masksToBounds = false
        return view
    }()
    
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "MinusIcon")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    lazy var label: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "1"
        view.textColor = UIColor(hex: "cccccc")
        view.textAlignment = .center
        view.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func layoutSubviews() {
        setLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
    var type: CartCounterType = .image {
        didSet {
            switch type {
            case .label:
                self.imageView.isHidden = true
                self.label.isHidden = false
                self.containerView.backgroundColor = .clear
            case .image:
                self.imageView.isHidden = false
                self.label.isHidden = true
                self.containerView.backgroundColor = .black
            }
        }
    }
    
    var clickedAction: (() -> Void)?
    
    func setLayout() {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 3),
            containerView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 3),
            containerView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -3),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -3)
        ])
        
        self.containerView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: self.containerView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: self.containerView.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 16),
            imageView.heightAnchor.constraint(equalToConstant: 16)
        ])
        
        self.containerView.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 4),
            label.leftAnchor.constraint(equalTo: self.containerView.leftAnchor, constant: 4),
            label.rightAnchor.constraint(equalTo: self.containerView.rightAnchor, constant: -4),
            label.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: -4)
        ])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(onClickCounter))
        containerView.addGestureRecognizer(tap)
    }
    
    @objc func onClickCounter() {
        self.clickedAction?()
    }
}

enum CartCounterType {
    case label
    case image
}

enum CounterOptions {
    case plus
    case negetive
}
