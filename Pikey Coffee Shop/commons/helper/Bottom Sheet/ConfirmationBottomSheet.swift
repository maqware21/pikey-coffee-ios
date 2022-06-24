//
//  LogoutViewController.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 16/06/2022.
//

import UIKit

protocol ConfirmationDelegate: AnyObject {
    func confirmAction()
}


class ConfirmationBottomSheet: UIView {

    weak var delegate: ConfirmationDelegate?
    
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
        view.text = "Logout"
        view.textColor = .white
        view.font = UIFont(name: "Cocogoose", size: 20)
        return view
    }()
    
    lazy var messageLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Are you sure you want to logout?"
        view.textColor = UIColor(named: "coffeeGray")
        view.font = UIFont(name: "Cocogoose-light", size: 18)
        view.numberOfLines = 0
        view.textAlignment = .center
        return view
    }()
    
    lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.spacing = 16
        view.distribution = .fillEqually
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
        label.text = "Yes"
        label.textColor = .black
        label.font = UIFont(name: "Cocogoose-light", size: 14)
        label.textAlignment = .center
        return label
    }()
    
    lazy var denyButton: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.borderWidth = 1
        view.borderColor = UIColor(named: "shadowColor")
        view.cornerRadius = 25
        return view
    }()
    
    lazy var noLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "No"
        label.textColor = .white
        label.font = UIFont(name: "Cocogoose-light", size: 14)
        label.textAlignment = .center
        return label
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
            titleLabel.centerXAnchor.constraint(equalTo: self.containerView.centerXAnchor)
        ])
        
        self.containerView.addSubview(messageLabel)
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            messageLabel.centerXAnchor.constraint(equalTo: self.containerView.centerXAnchor),
            messageLabel.leftAnchor.constraint(greaterThanOrEqualTo: self.containerView.leftAnchor, constant: 16),
            messageLabel.rightAnchor.constraint(lessThanOrEqualTo: self.containerView.rightAnchor, constant: -16)
        ])
        
        self.containerView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 32),
            stackView.leftAnchor.constraint(equalTo: self.containerView.leftAnchor, constant: 16),
            stackView.rightAnchor.constraint(equalTo: self.containerView.rightAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: -48),
            stackView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        stackView.addArrangedSubview(denyButton)
        stackView.addArrangedSubview(confirmButton)
        
        denyButton.addSubview(noLabel)
        NSLayoutConstraint.activate([
            noLabel.topAnchor.constraint(equalTo: denyButton.topAnchor),
            noLabel.leftAnchor.constraint(equalTo: denyButton.leftAnchor),
            noLabel.rightAnchor.constraint(equalTo: denyButton.rightAnchor),
            noLabel.bottomAnchor.constraint(equalTo: denyButton.bottomAnchor)
        ])
        
        confirmButton.addSubview(yesLabel)
        NSLayoutConstraint.activate([
            yesLabel.topAnchor.constraint(equalTo: confirmButton.topAnchor),
            yesLabel.leftAnchor.constraint(equalTo: confirmButton.leftAnchor),
            yesLabel.rightAnchor.constraint(equalTo: confirmButton.rightAnchor),
            yesLabel.bottomAnchor.constraint(equalTo: confirmButton.bottomAnchor)
        ])
        
        let yesTap = UITapGestureRecognizer(target: self, action: #selector(onClickYes))
        confirmButton.addGestureRecognizer(yesTap)
        
        let noTap = UITapGestureRecognizer(target: self, action: #selector(onClickNo))
        denyButton.addGestureRecognizer(noTap)
    }

    
    @objc func onClickYes() {
        self.delegate?.confirmAction()
    }
    
    @objc func onClickNo() {
        self.parentViewController?.dismiss(animated: true)
    }
}
