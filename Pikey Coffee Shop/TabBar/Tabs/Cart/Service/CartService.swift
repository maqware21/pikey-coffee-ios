//
//  CartService.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 15/11/2022.
//

import Foundation

protocol CartServiceable {
    func createOrder(cart: Cart?) async -> Result<Order, RequestError>
    func getOrders(page: Int) async -> Result<OrderList, RequestError>
    func cancelOrder(id: Int) async -> Result<Order, RequestError>
    func validateCoupon(code: String) async -> Result<CouponValidated, RequestError>
}

struct CartService: HTTPClient, CartServiceable {
    
    static let `shared` = CartService()
    
    func createOrder(cart: Cart?) async -> Result<Order, RequestError> {
        return await sendRequest(endpoint: CartEndpoint.createOrder(cart: cart), responseModel: Order.self)
    }
    
    func getOrders(page: Int) async -> Result<OrderList, RequestError> {
        return await sendRequest(endpoint: CartEndpoint.getOrders(page: page), responseModel: OrderList.self)
    }
    
    func cancelOrder(id: Int) async -> Result<Order, RequestError> {
        return await sendRequest(endpoint: CartEndpoint.cancelOrder(id: id), responseModel: Order.self)
    }
    
    func validateCoupon(code: String) async -> Result<CouponValidated, RequestError> {
        return await sendRequest(endpoint: CartEndpoint.validateCoupon(code: code), responseModel: CouponValidated.self)
    }
}
