//
//  IconTextField.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 02/06/2022.
//

import UIKit

class IconTextField: UITextField {
    
    
    @IBInspectable var iconSize: CGSize = .zero
    
    @IBInspectable var placeholderColor: UIColor? {
        didSet {
            if let placeholderColor = placeholderColor {
                self.setPlaceHolderTextColor(placeholderColor)
            }
        }
    }
    
    @IBInspectable var icon: UIImage? {
        didSet {
            if let icon = icon {
                let view = UIImageView(image: icon)
                view.frame = CGRect(x: 0, y: 0, width: iconSize.width, height: iconSize.height)
                self.leftView = view
                self.leftViewMode = .always
                self.leftViewTintColor = .white
            }
        }
    }
    
    let button = UIButton(type: .custom)
    
    func enablePasswordToggle() {
        
        button.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        button.setImage(UIImage(systemName: "eye.fill"), for: .selected)
        button.addTarget(self, action: #selector(togglePasswordView), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: iconSize.width, height: iconSize.height)
        button.tintColor = UIColor(named: "coffeeGray")
        rightView = button
        rightViewMode = .always
    }
    
    @objc func togglePasswordView(_ sender: Any) {
        isSecureTextEntry.toggle()
        button.isSelected.toggle()
    }
}
