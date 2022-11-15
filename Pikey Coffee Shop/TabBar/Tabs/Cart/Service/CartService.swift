//
//  CartService.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 15/11/2022.
//

import Foundation

protocol CartServiceable {
    func createOrder(cart: Cart?) async -> Result<Order, RequestError>
}

struct CartService: HTTPClient, CartServiceable {
    
    static let `shared` = CartService()
    
    func createOrder(cart: Cart?) async -> Result<Order, RequestError> {
        return await sendRequest(endpoint: CartEndpoint.createOrder(cart: cart), responseModel: Order.self)
    }
}
