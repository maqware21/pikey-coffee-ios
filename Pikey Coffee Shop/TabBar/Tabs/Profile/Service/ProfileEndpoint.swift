//
//  ProfileEndpoint.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 22/07/2022.
//
import Foundation

enum ProfileEndpoint {
    case getProfile
    case updateProfile(userName: String,
                       phoneNumber: String)
    case updatePassword(oldPassword: String,
                        newPassword: String,
                        confirmPassword: String)
    case getLocations(page: Int)
    case createLocation(location: PickeyAddress)
    case deleteLocation(id: Int)
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
        case .createLocation:
            return "/api/customer/locations"
        case .deleteLocation(let id):
            return "/api/customer/locations/\(id)"
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
        case .createLocation:
            return .post
        case .deleteLocation:
            return .delete
        }
    }
    
    var body: [String: Any]? {
        switch self {
        case .getProfile, .getLocations:
            return nil
        case .updateProfile(let name, let phoneNumber):
            guard let user = UserDefaults.standard[.user] else { return nil }
            let namecomponents = name.components(separatedBy: " ")
            let parameter: [String: String] = [
                                "email": user.email ?? "",
                                "first_name": namecomponents.first ?? "",
                                "last_name": namecomponents.last ?? "",
                                "phone_number": phoneNumber
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
        case .createLocation(let location):
            return try? location.toDictionary()
        case .deleteLocation:
            return nil
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

