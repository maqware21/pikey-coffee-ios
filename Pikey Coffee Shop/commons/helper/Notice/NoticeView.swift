//
//  NoticeView.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 20/07/2022.
//

import UIKit

class NoticeView: UIView {
    
    lazy var containerView: HorizontalGradientView = {
        let view = HorizontalGradientView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.cornerRadius = 10
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "notice"
        view.textColor = .black
        view.font = UIFont(name: "Cocogoose", size: 16)
        view.textAlignment = .center
        view.numberOfLines = 0
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLayout() {
        self.backgroundColor = .black
        self.containerView.backgroundColor = .black
        
        self.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.topAnchor),
            containerView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 32),
            containerView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -32),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        self.containerView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 16),
            titleLabel.leftAnchor.constraint(equalTo: self.containerView.leftAnchor, constant: 16),
            titleLabel.rightAnchor.constraint(equalTo: self.containerView.rightAnchor, constant: -16),
            titleLabel.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: -16)
        ])
        
    }
}
