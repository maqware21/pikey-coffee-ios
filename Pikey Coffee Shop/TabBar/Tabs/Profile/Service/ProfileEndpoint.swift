//
//  ProfileEndpoint.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 22/07/2022.
//
import Foundation

enum ProfileEndpoint {
    case getProfile
}

extension ProfileEndpoint: Endpoint {
    var path: String {
        switch self {
        case .getProfile:
            return "/api/customer/profile"
        }
    }

    var method: RequestMethod {
        switch self {
        case .getProfile:
            return .get
        }
    }

    var header: [String: String]? {
        switch self {
        case .getProfile:
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
        }
    }
}

