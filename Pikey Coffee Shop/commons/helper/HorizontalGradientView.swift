//
//  HorizontalGradientView.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 10/06/2022.
//

import UIKit

class HorizontalGradientView: UIView {
    
    lazy var gradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.white.cgColor, UIColor.lightGray.cgColor]
        gradient.locations = [0, 1]
        gradient.startPoint = CGPoint(x: 0, y: 1)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        return gradient
    }()
    
    override func layoutSubviews() {
        gradient.frame = self.bounds
        self.layer.insertSublayer(gradient, at: 0)
    }
}
