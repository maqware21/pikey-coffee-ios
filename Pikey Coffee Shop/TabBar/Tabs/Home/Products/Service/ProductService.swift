//
//  ProductService.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 28/10/2022.
//

import Foundation

protocol ProductServiceable {
    func getProduct(id: Int, page: Int) async -> Result<ProductData, RequestError>
    func getMerchandise(page: Int) async -> Result<ProductData, RequestError>
}

struct ProductService: HTTPClient, ProductServiceable {
    
    static let `shared` = ProductService()
    
    func getProduct(id: Int, page: Int) async -> Result<ProductData, RequestError> {
        return await sendRequest(endpoint: HomeEndpoint.getProducts(categoryId: id, page: page), responseModel: ProductData.self)
    }
    
    func getMerchandise(page: Int) async -> Result<ProductData, RequestError> {
        return await sendRequest(endpoint: HomeEndpoint.getMerchandise(page: page, type: 1), responseModel: ProductData.self)
    }
}
