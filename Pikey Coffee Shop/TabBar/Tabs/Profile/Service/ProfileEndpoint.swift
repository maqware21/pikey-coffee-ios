//
//  ProfileEndpoint.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 22/07/2022.
//
import Foundation

enum ProfileEndpoint {
    case getProfile
    case updateProfile(userName: String)
    case updatePassword(oldPassword: String,
                        newPassword: String,
                        confirmPassword: String)
    case getLocations(page: Int)
}

extension ProfileEndpoint: Endpoint {
    var path: String {
        switch self {
        case .getProfile:
            return "/api/customer/profile"
        case .updatePassword, .updateProfile:
            return "/api/customer/profile"
        case .getLocations:
            return "/api/customer/locations"
        }
    }

    var method: RequestMethod {
        switch self {
        case .getProfile:
            return .get
        case .updatePassword, .updateProfile:
            return .put
        case .getLocations:
            return .get
        }
    }
    
    var body: [String: String]? {
        switch self {
        case .getProfile, .getLocations:
            return nil
        case .updateProfile(let name):
            guard let user = UserDefaults.standard[.user] else { return nil }
            let namecomponents = name.components(separatedBy: " ")
            let parameter: [String: String] = [
                                "email": user.email ?? "",
                                "first_name": namecomponents.first ?? "",
                                "last_name": namecomponents.last ?? "",
                                "phone_number": user.phoneNumber ?? ""
                            ]
            return parameter
        case .updatePassword(let oldPassword, let newPassword, let confirmPassword):
            guard let user = UserDefaults.standard[.user] else { return nil }
            let parameter: [String: String] = [
                                "email": user.email ?? "",
                                "first_name": user.firstName ?? "",
                                "last_name": user.lastName ?? "",
                                "phone_number": user.phoneNumber ?? "",
                                "password": newPassword,
                                "old_password":oldPassword,
                                "password_confirmation": confirmPassword
                            ]
            return parameter
        }
    }
    
    var queryParams: [URLQueryItem]? {
        switch self {
        case .getLocations(let page):
            let parameter: [URLQueryItem] = [
                URLQueryItem(name: "page", value: String(page)),
                URLQueryItem(name: "per_page", value: String(AddressConstant.perPageCount))
            ]
            return parameter
        default:
            return nil
        }
    }
}

