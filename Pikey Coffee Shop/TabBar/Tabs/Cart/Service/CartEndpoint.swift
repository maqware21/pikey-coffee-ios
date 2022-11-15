//
//  CartEndpoint.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 15/11/2022.
//

import Foundation

enum CartEndpoint {
    case createOrder(cart: Cart?)
}

extension CartEndpoint: Endpoint {
    
    var path: String {
        switch self {
        case .createOrder:
            return "/api/customer/orders"
        }
    }

    var method: RequestMethod {
        switch self {
        case .createOrder:
            return .post
        }
    }
    
    var body: [String: Any]? {
        switch self {
        case .createOrder(let cart):
            return try? cart.toDictionary()
        }
    }
    
    var queryParams: [URLQueryItem]? {
        switch self {
        default:
            return nil
        }
    }
}
