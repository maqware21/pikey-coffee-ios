//
//  Array+Extension.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 09/11/2022.
//

import Foundation
import GooglePlaces

extension Array where Element == GMSAddressComponent {
    func valueFor(placeTypes: String..., shortName: Bool = false) -> String? {
        let array = self as NSArray
        let result = array
            .compactMap { $0 as? GMSAddressComponent }
            .first(where: {
                placeTypes.contains($0.types.first(where: { placeTypes.contains($0) }) ?? "")
            })
        return shortName ? result?.shortName : result?.name
    }
}
