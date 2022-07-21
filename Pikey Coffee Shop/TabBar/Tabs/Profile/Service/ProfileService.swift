//
//  ProfileService.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 22/07/2022.
//

import Foundation

protocol ProfileServiceable {
    func getProfile() async -> Result<User, RequestError>
}

struct ProfileService: HTTPClient, ProfileServiceable {
    
    static let `shared` = ProfileService()
    
    func getProfile() async -> Result<User, RequestError> {
        return await sendRequest(endpoint: ProfileEndpoint.getProfile, responseModel: User.self)
    }
    
    
}
