//
//  CartEndpoint.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 15/11/2022.
//

import Foundation

enum CartEndpoint {
    case createOrder(cart: Cart?)
    case getOrders
}

extension CartEndpoint: Endpoint {
    
    var path: String {
        switch self {
        case .createOrder, .getOrders:
            return "/api/customer/orders"
        }
    }

    var method: RequestMethod {
        switch self {
        case .createOrder:
            return .post
        case .getOrders:
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
        default:
            return nil
        }
    }
}
