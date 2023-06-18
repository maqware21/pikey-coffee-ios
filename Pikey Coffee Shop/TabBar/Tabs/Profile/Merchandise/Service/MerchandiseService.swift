//
//  MerchandiseService.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 18/06/2023.
//

import UIKit

protocol MerchandiseServiceable {
    func getCategories() async -> Result<[MerchandiseCategory], RequestError>
}

struct MerchandiseService: HTTPClient, MerchandiseServiceable {
    
    static let `shared` = MerchandiseService()
    
    func getCategories() async -> Result<[MerchandiseCategory], RequestError> {
        return await sendRequest(endpoint: ProfileEndpoint.getMerchandisingCategories, responseModel: [MerchandiseCategory].self)
    }
}
