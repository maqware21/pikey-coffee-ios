//
//  ProfileService.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 22/07/2022.
//

import Foundation

protocol ProfileServiceable {
    func getProfile() async -> Result<User, RequestError>
    func updateProfile(userName: String,
                       phoneNumber: String) async -> Result<User, RequestError>
    func updatePassword(oldPassword: String,
                        newPassword: String,
                        confirmPassword: String) async -> Result<User, RequestError>
    func getAddresses(page: Int) async -> Result<AddressList, RequestError>
    func createAddress(address: PickeyAddress) async -> Result<PickeyAddress, RequestError>
    func deleteAddress(id: Int) async -> Result<ForgotPassword, RequestError>
}

struct ProfileService: HTTPClient, ProfileServiceable {
    
    static let `shared` = ProfileService()
    
    func getProfile() async -> Result<User, RequestError> {
        return await sendRequest(endpoint: ProfileEndpoint.getProfile, responseModel: User.self)
    }
    
    func updateProfile(userName: String, phoneNumber: String) async -> Result<User, RequestError> {
        return await sendRequest(endpoint: ProfileEndpoint.updateProfile(userName: userName, phoneNumber: phoneNumber), responseModel: User.self)
    }
    
    func updatePassword(oldPassword: String, newPassword: String, confirmPassword: String) async -> Result<User, RequestError> {
        return await sendRequest(endpoint: ProfileEndpoint.updatePassword(oldPassword: oldPassword, newPassword: newPassword, confirmPassword: confirmPassword), responseModel: User.self)
    }
    
    func getAddresses(page: Int) async -> Result<AddressList, RequestError> {
        return await sendRequest(endpoint: ProfileEndpoint.getLocations(page: page), responseModel: AddressList.self)
    }
    
    func createAddress(address: PickeyAddress) async -> Result<PickeyAddress, RequestError> {
        return await sendRequest(endpoint: ProfileEndpoint.createLocation(location: address), responseModel: PickeyAddress.self)
    }
    
    func deleteAddress(id: Int) async -> Result<ForgotPassword, RequestError> {
        return await sendRequest(endpoint: ProfileEndpoint.deleteLocation(id: id), responseModel: ForgotPassword.self)
    }
}
