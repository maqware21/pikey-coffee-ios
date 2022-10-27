//
//  Products.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 23/10/2022.
//

import Foundation

// MARK: - Constants
struct ProductConstants {
    static let perPageCount = 30
}

struct ProductData: Codable {
    var data: [Product]?
    var pagination: Pagination?
}

// MARK: - Datum
struct Product: Codable {
    let id: Int?
    let name: String?
    let shortDescription, longDescription: String?
    let price, priceInPoints: Int?
    let sku: String?
    let type, selectedQuantity, isTaxable: Int?
    let addons: [Product]?
    let images: [Image]?
    let categories: [Category]?

    enum CodingKeys: String, CodingKey {
        case id, name
        case shortDescription = "short_description"
        case longDescription = "long_description"
        case price
        case priceInPoints = "price_in_points"
        case sku, type
        case selectedQuantity = "selected_quantity"
        case isTaxable = "is_taxable"
        case addons, images, categories
    }
}
