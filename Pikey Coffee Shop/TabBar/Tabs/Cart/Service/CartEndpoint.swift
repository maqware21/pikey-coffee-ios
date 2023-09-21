//
//  CartEndpoint.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 15/11/2022.
//

import Foundation

enum CartEndpoint {
    case createOrder(cart: Cart?)
    case getOrders(page: Int)
    case cancelOrder(id: Int)
    case validateCoupon(code: String)
}

extension CartEndpoint: Endpoint {
    
    var path: String {
        switch self {
        case .createOrder, .getOrders:
            return "/api/customer/orders"
        case .cancelOrder(let id):
            return "/api/customer/orders/\(id)/cancel"
        case .validateCoupon(let code):
            return "/api/promotions/validate/\(code)"
        }
    }

    var method: RequestMethod {
        switch self {
        case .createOrder:
            return .post
        case .getOrders:
            return .get
        case .cancelOrder:
            return .put
        case .validateCoupon:
            return .get
        }
    }
    
    var body: [String: Any]? {
        switch self {
        case .createOrder(let cart):
            return try? cart.toDictionary()
        default:
            return nil
        }
    }
    
    var queryParams: [URLQueryItem]? {
        switch self {
        case .getOrders(let page):
            let parameter: [URLQueryItem] = [
                URLQueryItem(name: "page", value: String(page)),
                URLQueryItem(name: "per_page", value: String(OrderConstants.perPageCount))
            ]
            return parameter
        default:
            return nil
        }
    }
}
