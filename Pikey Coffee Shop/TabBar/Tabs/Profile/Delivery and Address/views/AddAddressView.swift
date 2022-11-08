//
//  DeliveryViewController.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 17/06/2022.
//

import UIKit
import GoogleMaps
import CoreLocation

typealias AddressViewTypeCall = ((_:IconButtonType) -> Void)

class AddAddressView: UIView {
    
    var locationManager: CLLocationManager?
    var typeSelected: AddressViewTypeCall?
    
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
        view.text = "Add Address"
        view.textColor = .white
        view.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return view
    }()
    
    lazy var cancelButton: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.borderWidth = 1
        view.borderColor = UIColor(named: "shadowColor")
        view.cornerRadius = 15
        return view
    }()
    
    lazy var cancelLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Cancel"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()
    
    lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.spacing = 16
        view.distribution = .fillEqually
        return view
    }()
    
    lazy var saveLocationButton: HorizontalGradientView = {
        let view = HorizontalGradientView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.cornerRadius = 22
        return view
    }()
    
    lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Save Location"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
            titleLabel.leftAnchor.constraint(equalTo: self.containerView.leftAnchor, constant: 16)
        ])
        
        self.containerView.addSubview(cancelButton)
        NSLayoutConstraint.activate([
            cancelButton.centerYAnchor.constraint(equalTo: self.titleLabel.centerYAnchor, constant: 0),
            cancelButton.rightAnchor.constraint(equalTo: self.containerView.rightAnchor, constant: -16),
            cancelButton.heightAnchor.constraint(equalToConstant: 30),
            cancelButton.widthAnchor.constraint(equalToConstant: 96),
            cancelButton.leftAnchor.constraint(greaterThanOrEqualTo: self.titleLabel.rightAnchor, constant: 16)
        ])
        
        self.cancelButton.addSubview(cancelLabel)
        NSLayoutConstraint.activate([
            cancelLabel.topAnchor.constraint(equalTo: self.cancelButton.topAnchor),
            cancelLabel.leftAnchor.constraint(equalTo: self.cancelButton.leftAnchor),
            cancelLabel.rightAnchor.constraint(equalTo: self.cancelButton.rightAnchor),
            cancelLabel.bottomAnchor.constraint(equalTo: self.cancelButton.bottomAnchor)
        ])
        
        self.containerView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 32),
            stackView.leftAnchor.constraint(equalTo: self.titleLabel.leftAnchor),
            stackView.rightAnchor.constraint(equalTo: self.cancelLabel.rightAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        let homeButton = PikeyIconButton(frame: .zero)
        let officeButton = PikeyIconButton(frame: .zero)
        let otherButton = PikeyIconButton(frame: .zero)
        
        homeButton.type = .Home
        homeButton.selected = true
        homeButton.tapped = {
            homeButton.selected = true
            officeButton.selected = false
            otherButton.selected = false
            self.typeSelected?(.Home)
        }
        officeButton.type = .Office
        officeButton.selected = false
        officeButton.tapped = {
            officeButton.selected = true
            homeButton.selected = false
            otherButton.selected = false
            self.typeSelected?(.Office)
        }
        otherButton.type = .Other
        otherButton.selected = false
        otherButton.tapped = {
            otherButton.selected = true
            homeButton.selected = false
            officeButton.selected = false
            self.typeSelected?(.Other)
        }
        
        stackView.addArrangedSubview(homeButton)
        stackView.addArrangedSubview(officeButton)
        stackView.addArrangedSubview(otherButton)
        
        
        containerView.addSubview(saveLocationButton)
        NSLayoutConstraint.activate([
            saveLocationButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 32),
            saveLocationButton.leftAnchor.constraint(equalTo: self.titleLabel.leftAnchor),
            saveLocationButton.rightAnchor.constraint(equalTo: self.cancelButton.rightAnchor),
            saveLocationButton.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: -32),
            saveLocationButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        saveLocationButton.addSubview(locationLabel)
        NSLayoutConstraint.activate([
            locationLabel.topAnchor.constraint(equalTo: saveLocationButton.topAnchor),
            locationLabel.leftAnchor.constraint(equalTo: saveLocationButton.leftAnchor),
            locationLabel.rightAnchor.constraint(equalTo: saveLocationButton.rightAnchor),
            locationLabel.bottomAnchor.constraint(equalTo: saveLocationButton.bottomAnchor)
        ])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(onCancel))
        cancelButton.addGestureRecognizer(tap)
        
    }
    
    @objc func onCancel() {
        self.parentViewController?.dismiss(animated: true)
    }
}
