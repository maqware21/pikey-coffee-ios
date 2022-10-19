//
//  HomeService.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 18/10/2022.
//

import Foundation

protocol HomeServiceable {
    func getCategories(page: Int) async -> Result<CategoryData, RequestError>
}

struct HomeService: HTTPClient, HomeServiceable {
    
    static let `shared` = HomeService()
    
    func getCategories(page: Int) async -> Result<CategoryData, RequestError> {
        return await sendRequest(endpoint: HomeEndpoint.getCategories(page: page), responseModel: CategoryData.self)
    }
    
}
