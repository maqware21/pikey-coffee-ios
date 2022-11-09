//
//  PikeyIconButton.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 25/06/2022.
//

import UIKit

class PikeyIconButton: UIView {
    
    private lazy var containerView: HorizontalGradientView = {
        let view = HorizontalGradientView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.cornerRadius = 20
        view.borderColor = UIColor(named: "shadowColor")
        return view
    }()
    
    private lazy var iconView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = .white
        return view
    }()
    
    private lazy var labelView: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Home"
        view.textColor = UIColor(hex: "coffeeGray")
        view.font = UIFont.systemFont(ofSize: 18)
        return view
    }()
    
    private var image: UIImage? {
        didSet {
            if let image = image {
                self.iconView.image = image.withRenderingMode(.alwaysTemplate)
            }
        }
    }
    
    private var title: String = "" {
        didSet {
            labelView.text = title
        }
    }
    
    var type: IconButtonType! {
        didSet {
            switch type {
            case .Home:
                self.title = "Home"
                self.image = UIImage(named: "homeIcon")
            case .Office:
                self.title = "Office"
                self.image = UIImage(named: "officeIcon")
            case .Other:
                self.title = "Other"
                self.image = UIImage(named: "locationMarker")
            case .none:
                break
            }
        }
    }
    
    var selected: Bool = false {
        didSet {
            if selected {
                self.containerView.borderWidth = 0
                self.containerView.backgroundColor = .white
                self.labelView.textColor = .black
                self.iconView.tintColor = .black
                self.containerView.gradient.isHidden = false
            } else {
                self.containerView.borderWidth = 1
                self.containerView.backgroundColor = .black
                self.labelView.textColor = UIColor(named: "coffeeGray")
                self.iconView.tintColor = .white
                self.containerView.gradient.isHidden = true
            }
        }
    }
    
    var tapped: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLayout() {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        
        self.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.topAnchor),
            containerView.leftAnchor.constraint(equalTo: self.leftAnchor),
            containerView.rightAnchor.constraint(equalTo: self.rightAnchor),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        containerView.addSubview(iconView)
        NSLayoutConstraint.activate([
            iconView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 32),
            iconView.heightAnchor.constraint(equalToConstant: 32)
        ])
        
        containerView.addSubview(labelView)
        NSLayoutConstraint.activate([
            labelView.topAnchor.constraint(equalTo: containerView.topAnchor),
            labelView.rightAnchor.constraint(lessThanOrEqualTo: containerView.rightAnchor),
            labelView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            labelView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: 8),
            labelView.leftAnchor.constraint(equalTo: iconView.rightAnchor, constant: 0),
        ])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(onClick))
        containerView.addGestureRecognizer(tap)
    }
    
    @objc func onClick() {
        tapped?()
    }
}


enum IconButtonType {
    case Home
    case Office
    case Other(String?)
    
    var name: String {
        switch self {
        case .Home:
            return "home"
        case .Office:
            return "office"
        case .Other(let string):
            return string ?? ""
        }
    }
}
