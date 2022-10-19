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
    var pagination: CategoryPagination?
}

// MARK: - Category
struct Category: Codable {
    let id: Int
    let name, shortDescription, longDescription: String?
    let images: [CategoryImage]?
    let parentID: Int?
    let type: Int?
    let children: [Category]?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case shortDescription = "short_description"
        case longDescription = "long_description"
        case images, children
        case parentID = "parent_id"
        case type
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - CategoryImage
struct CategoryImage: Codable {
    let id: Int?
    let path: String?
    let index: Int?
}

// MARK: - CategoryPagination
struct CategoryPagination: Codable {
    let total, count, perPage, currentPage: Int?
    let totalPages: Int?
    let links: CategoryPaginationLinks?

    enum CodingKeys: String, CodingKey {
        case total, count
        case perPage = "per_page"
        case currentPage = "current_page"
        case totalPages = "total_pages"
        case links
    }
}

// MARK: - CategoryPaginationLinks
struct CategoryPaginationLinks: Codable {
    let previous: String?
    let next: String?
}
