//
//  MoviesService.swift
//  RequestApp
//
//  Created by Victor Catão on 18/02/22.
//

import Foundation

protocol RegisterServiceable {
    func signUp(name: String,
                email: String,
                password: String,
                phoneNo: String) async -> Result<UserData, RequestError>
    
    func signIn(email: String,
                password: String) async -> Result<User, RequestError>
}

struct RegisterService: HTTPClient, RegisterServiceable {
    
    static let `shared` = RegisterService()
    
    func signUp(name: String,
                email: String,
                password: String,
                phoneNo: String) async -> Result<UserData, RequestError> {
        return await sendRequest(endpoint: RegistrationEndpoint.signUp(name: name, email: email, password: password, phoneNo: phoneNo), responseModel: UserData.self)
    }
    
    func signIn(email: String,
                password: String) async -> Result<User, RequestError> {
        return await sendRequest(endpoint: RegistrationEndpoint.signIn(email: email, password: password), responseModel: User.self)
    }
}
