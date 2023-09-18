//
//  GiftCard.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 17/09/2023.
//

import Foundation

struct GiftCard: Codable {
    let paymentMethod: Int?
    let token: String?
    let gift: Gift?

    enum CodingKeys: String, CodingKey {
        case paymentMethod = "payment_method"
        case token, gift
    }
}

// MARK: - Gift
struct Gift: Codable {
    let toName, fromName, toEmail, fromEmail: String?
    let amount: Double?
    let message: String?

    enum CodingKeys: String, CodingKey {
        case toName = "to_name"
        case fromName = "from_name"
        case toEmail = "to_email"
        case fromEmail = "from_email"
        case amount, message
    }
}


struct GiftCardResp: Codable {
    let success: Bool?
}
