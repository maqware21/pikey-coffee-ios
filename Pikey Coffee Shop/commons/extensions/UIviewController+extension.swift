//
//  UIviewController+extension.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 20/07/2022.
//

import UIKit
import NVActivityIndicatorView

extension UIViewController {
    
    func showLoader() {
        let backgroundView = UIView(frame: .zero)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.backgroundColor = UIColor(hex: "222222")
        backgroundView.alpha = 0.7
        let view = NVActivityIndicatorView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.tag = 0xDEADBEEF
        self.view.addSubview(backgroundView)
        backgroundView.addSubview(view)
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: self.view.topAnchor),
            backgroundView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            backgroundView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            view.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            view.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            view.heightAnchor.constraint(equalToConstant: 72),
            view.widthAnchor.constraint(equalToConstant: 72)
        ])
        view.type = .circleStrokeSpin
        view.startAnimating()
    }
    
    func removeLoader() {
        if let view = self.view.subviews.first(where: { $0.tag == 0xDEADBEEF }) {
            view.removeFromSuperview()
        }
    }
}
