//
//  ProductViewModel.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 28/10/2022.
//

import Foundation

protocol ProductsDelegate: AnyObject {
    func productsUpdate(with products: ProductData?)
}

import Foundation

class ProductViewModel {
    
    weak var delegate: ProductsDelegate?
    
    func getProducts(with id: Int,
                       for page: Int) {
        Task(priority: .background) {
            let result = await ProductService.shared.getProduct(id: id, page: page)
            switch result {
            case .success(let data):
                delegate?.productsUpdate(with: data)
            case .failure(let error):
                delegate?.productsUpdate(with: nil)
                print(error.customMessage)
            }
        }
    }
}
