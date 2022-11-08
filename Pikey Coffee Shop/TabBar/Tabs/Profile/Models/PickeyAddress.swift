//
//  File.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 07/11/2022.
//

import Foundation

struct PickeyAddress: Codable {
    var id: Int?
    var name: String?
    var isPrimary: Int?
    var address, city, state, postalCode: String?
    var latitude: String?
    var longitude: String?
    var userId: Int?
    var type: Int?

    enum CodingKeys: String, CodingKey {
        case id, name
        case isPrimary = "is_primary"
        case address, city, state
        case postalCode = "postal_code"
        case latitude, longitude, type
        case userId = "user_id"
    }
    
    init(name: String?, isPrimary: Int?, address: String?, city: String?, state: String?, postalCode: String?, latitude: String?, longitude: String?, type: Int?) {
        self.name = name
        self.isPrimary = isPrimary
        self.address = address
        self.city = city
        self.state = state
        self.postalCode = postalCode
        self.latitude = latitude
        self.longitude = longitude
        self.type = type
    }
}

struct AddressList: Codable {
    var data: [PickeyAddress]?
    var pagination: Pagination?
}

struct AddressConstant {
    static let perPageCount = 30
}
