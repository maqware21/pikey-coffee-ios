//
//  HomeEndpoint.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 18/10/2022.
//

import Foundation

enum HomeEndpoint {
    case getCategories(page: Int)
}

extension HomeEndpoint: Endpoint {
    var path: String {
        switch self {
        case .getCategories:
            return "/api/categories"
        }
    }

    var method: RequestMethod {
        switch self {
        case .getCategories:
            return .get
        }
    }
    
    var body: [String: String]? {
        switch self {
        case .getCategories:
            return nil
        }
    }
    
    var queryParams: [URLQueryItem]? {
        switch self {
        case .getCategories(let page):
            let parameter: [URLQueryItem] = [
                URLQueryItem(name: "page", value: String(page)),
                URLQueryItem(name: "per_page", value: String(CategoryConstants.perPageCount))
            ]
            return parameter
        }
    }
}
