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
}

extension ProfileEndpoint: Endpoint {
    var path: String {
        switch self {
        case .getProfile:
            return "/api/customer/profile"
        case .updatePassword, .updateProfile:
            return "/api/customer/profile"
        }
    }

    var method: RequestMethod {
        switch self {
        case .getProfile:
            return .get
        case .updatePassword, .updateProfile:
            return .put
        }
    }

    var header: [String: String]? {
        switch self {
        case .getProfile, .updatePassword, .updateProfile:
            return [
                "Accept": "application/json",
                "Content-Type": "application/json;charset=utf-8",
                "Authorization": "Bearer \(UserDefaults.standard[.user]?.accessToken ?? "")"
            ]
        }
    }
    
    var body: [String: String]? {
        switch self {
        case .getProfile:
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
}

