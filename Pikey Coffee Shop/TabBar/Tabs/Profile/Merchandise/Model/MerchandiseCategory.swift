//
//  File.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 18/06/2023.
//

import Foundation

struct MerchandiseCategory: Codable {
    let id: Int?
    let name, shortDescription, longDescription: String?
    let images: [Image]?
    let index: Int?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case shortDescription = "short_description"
        case longDescription = "long_description"
        case images, index
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
