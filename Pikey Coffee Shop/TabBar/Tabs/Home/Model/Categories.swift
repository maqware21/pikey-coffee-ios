//
//  Categories.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 18/10/2022.
//

import Foundation

// MARK: - Constants
struct CategoryConstants {
    static let perPageCount = 30
}


// MARK: - CategoryData
struct CategoryData: Codable {
    var data: [Category]?
    var pagination: Pagination?
}

// MARK: - Category
struct Category: Codable {
    let id: Int?
    let name, shortDescription, longDescription: String?
    let images: [Image]?
    let parentID: Int?
    let type: Int?
    let children: [Category]?
    let createdAt, updatedAt: String?
    let modifiers: [Modifiers]?

    enum CodingKeys: String, CodingKey {
        case id, name
        case shortDescription = "short_description"
        case longDescription = "long_description"
        case images, children
        case parentID = "parent_id"
        case type
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case modifiers
    }
}


struct Modifiers: Codable {
    let id: Int?
    let name: String?
    let options: [Options]?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, name, options
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct Options: Codable {
    let id: Int?
    let name: String?
    let createdAt, updatedAt: String?
    let price: Double?

    enum CodingKeys: String, CodingKey {
        case id, name
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case price
    }
}
