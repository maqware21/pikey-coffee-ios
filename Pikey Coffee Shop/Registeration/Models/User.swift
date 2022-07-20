//
//  User.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 19/07/2022.
//

import Foundation

struct User: Codable {
    
    let id: Int
    let firstName: String?
    let lastName: String?
    let email: String?
    let phoneNumber: String?
    let type: Int?
    let isEmailVerified: Int?
    let isEmailVerifiedText: String?
    let isPhoneVerified: Int?
    let isPhoneVerifiedText: String?
    let role: String?
    let createdAt: String?
    let updatedAt: String?
    let accessToken: String?
    let refreshToken: String?
    let accessTokenExp: Int?
    let points: Int?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case phoneNumber = "phone_number"
        case type
        case isEmailVerified = "is_email_verified"
        case isEmailVerifiedText = "is_email_verified_text"
        case isPhoneVerified = "is_phone_verified"
        case isPhoneVerifiedText = "is_phone_verified_text"
        case role
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case accessTokenExp = "access_token_expires_in"
        case points
    }
}

struct UserData: Codable {
    let data: User?
}
