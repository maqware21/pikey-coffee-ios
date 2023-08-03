//
//  ModifierView.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 25/07/2023.
//

import UIKit

class ModifierView: UIView, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    var modifier: Modifiers? {
        didSet {
            guard let modifier else { return }
            self.titleLabel.text = modifier.name
            self.optionField.text = modifier.selectedOption?.name ?? modifier.options?.first?.name
            self.selectedOption = modifier.options?.first
            self.pickerView.reloadAllComponents()
        }
    }
    
    var selectedOption: Options?
    
    var modifierUpdated: ((_: Options?) -> Void)?
    
    var pickerView = UIPickerView()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.borderWidth = 1
        view.borderColor = UIColor(named: "shadowColor")
        view.cornerRadius = 10
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .white
        view.textAlignment = .left
        view.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        view.numberOfLines = 0
        return view
    }()
    
    lazy var optionField: UITextField = {
        let view = UITextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .black
        view.textAlignment = .left
        view.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        view.backgroundColor = .white
        view.borderStyle = .roundedRect
        view.delegate = self
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
        pickerView.dataSource = self
        pickerView.delegate = self
        
        optionField.inputView = pickerView
        
        self.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            containerView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 24),
            containerView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -24),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
        ])
        
        containerView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            titleLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8),
            titleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8)
        ])
        
        containerView.addSubview(optionField)
        NSLayoutConstraint.activate([
            optionField.topAnchor.constraint(greaterThanOrEqualTo: containerView.topAnchor, constant: 8),
            optionField.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -8),
            optionField.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -8),
            optionField.leftAnchor.constraint(equalTo: titleLabel.rightAnchor, constant: 16),
            optionField.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.6),
            optionField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return modifier?.options?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return modifier?.options?[row].name ?? ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.optionField.text = modifier?.options?[row].name
        self.selectedOption = modifier?.options?[row]
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.modifierUpdated?(selectedOption)
    }
}
