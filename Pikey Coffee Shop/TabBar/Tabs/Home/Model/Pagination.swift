//
//  Pagination.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 28/10/2022.
//

import Foundation

struct Pagination: Codable {
    let total, count, perPage, currentPage: Int?
    let totalPages: Int?
    let links: PaginationLinks?

    enum CodingKeys: String, CodingKey {
        case total, count
        case perPage = "per_page"
        case currentPage = "current_page"
        case totalPages = "total_pages"
        case links
    }
}

struct PaginationLinks: Codable {
    let previous: String?
    let next: String?
}
