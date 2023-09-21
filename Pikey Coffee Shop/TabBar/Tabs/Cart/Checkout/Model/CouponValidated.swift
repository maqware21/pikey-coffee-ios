//
//  CouponValidated.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 21/09/2023.
//

import Foundation

struct CouponValidated: Codable {
    let id: Int?
    let name, code: String?
    let discountPercentage: Double?
    let discountAmount: Double?
    let isPercentage, isFixedAmount: Bool?
    let startDate, endDate: String?
    let status: Int?

    enum CodingKeys: String, CodingKey {
        case id, name, code
        case discountPercentage = "discount_percentage"
        case discountAmount = "discount_amount"
        case isPercentage = "is_percentage"
        case isFixedAmount = "is_fixed_amount"
        case startDate = "start_date"
        case endDate = "end_date"
        case status
    }
}
