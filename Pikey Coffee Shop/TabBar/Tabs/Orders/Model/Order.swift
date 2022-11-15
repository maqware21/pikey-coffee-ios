//
//  Order.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 15/11/2022.
//

import Foundation

struct Order: Codable {
    let id, status: Int?
    let statusInText: String?
    let type: Int?
    let typeInText: String?
    let paymentMethod: Int?
    let paymentMethodInText, userFirstName, userLastName, userEmail: String?
    let userComment: String?
    let totalPrice: Int?
    let deliveryDate: String?
    let pickupDate: String?
    let locationID: Int?
    let userID: Int?
    let discountPercentage: Int?
    let discountAmount, paidPrice: Int
    let carNumber, parkingSpotNumber: String?
    let items: [OrderedItem]?
    let location: PickeyAddress?
    let transaction: Transaction?
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id, status
        case statusInText = "status_in_text"
        case type
        case typeInText = "type_in_text"
        case paymentMethod = "payment_method"
        case paymentMethodInText = "payment_method_in_text"
        case userFirstName = "user_first_name"
        case userLastName = "user_last_name"
        case userEmail = "user_email"
        case userComment = "user_comment"
        case totalPrice = "total_price"
        case deliveryDate = "delivery_date"
        case pickupDate = "pickup_date"
        case locationID = "location_id"
        case userID = "user_id"
        case discountPercentage = "discount_percentage"
        case discountAmount = "discount_amount"
        case paidPrice = "paid_price"
        case carNumber = "car_number"
        case parkingSpotNumber = "parking_spot_number"
        case items, location, transaction
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - OrderedItem
struct OrderedItem: Codable {
    let id, quantity: Int?
    let parentID: Int?
    let productID: Int?
    let productName, productSku: String?
    let productPrice, totalPrice: Int?
    let comments: String?
    let discountPercentage, discountAmount: Int?
    let addons: [Item]?

    enum CodingKeys: String, CodingKey {
        case id, quantity
        case parentID = "parent_id"
        case productID = "product_id"
        case productName = "product_name"
        case productSku = "product_sku"
        case productPrice = "product_price"
        case totalPrice = "total_price"
        case comments
        case discountPercentage = "discount_percentage"
        case discountAmount = "discount_amount"
        case addons
    }
}

// MARK: - Transaction
struct Transaction: Codable {
    let amount, status: Int?
    let statusInText: String?
    let type: Int?
    let typeInText: String?
    let orderID: Int?
    let paymentProfileID, providerTransactionID: Int?

    enum CodingKeys: String, CodingKey {
        case amount, status
        case statusInText = "status_in_text"
        case type
        case typeInText = "type_in_text"
        case orderID = "order_id"
        case paymentProfileID = "payment_profile_id"
        case providerTransactionID = "provider_transaction_id"
    }
}
