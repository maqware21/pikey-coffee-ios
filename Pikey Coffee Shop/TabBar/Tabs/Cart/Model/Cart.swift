//
//  Cart.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 31/10/2022.
//

import Foundation

struct Cart: Codable {
    let paymentMethod: Int?
    let token: String?
    let type: Int?
    let userComment: String?
    let locationID: Int?
    let deliveryDate: String?
    let items: [Item]?

    enum CodingKeys: String, CodingKey {
        case paymentMethod = "payment_method"
        case token, type
        case userComment = "user_comment"
        case locationID = "location_id"
        case deliveryDate = "delivery_date"
        case items
    }
}

struct Item: Codable {
    let productID, quantity: Int?
    let addons: [Item]?

    enum CodingKeys: String, CodingKey {
        case productID = "product_id"
        case quantity, addons
    }
}
