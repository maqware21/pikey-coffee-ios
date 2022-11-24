//
//  AddressViewModel.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 08/11/2022.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation



class AddressViewModel {
    
    var seletedPlace: GMSPlace?
    var fetchedAddress: GMSAddress?
    var selectedCoordinates: CLLocationCoordinate2D?
    var addressName: String = IconButtonType.Home.name
    weak var delegate: ProfileDelegate?
    
    func createAddress() {
        if let address = getAddress() {
            Task(priority: .background) {
                let result = await ProfileService.shared.createAddress(address: address)
                switch result {
                case .success(_):
                    delegate?.addressCreated()
                case .failure(let failure):
                    delegate?.addressCreated()
                    print(failure.customMessage)
                }
            }
        }
    }
    
    func getAddress() -> PickeyAddress? {
        var selectedAddress: PickeyAddress?
        if let seletedPlace {
            selectedAddress = PickeyAddress(name: nil,
                                            isPrimary: 0,
                                            address: seletedPlace.formattedAddress,
                                            city: seletedPlace.addressComponents?.valueFor(placeTypes: "administrative_area_level_2"),
                                            state: seletedPlace.addressComponents?.valueFor(placeTypes: "administrative_area_level_1"),
                                            postalCode: seletedPlace.addressComponents?.valueFor(placeTypes: "postal_code"),
                                            latitude: seletedPlace.coordinate.latitude.formatted(),
                                            longitude: seletedPlace.coordinate.longitude.formatted(),
                                            type: 1)
            if let selectedCoordinates {
                selectedAddress?.longitude = selectedCoordinates.longitude.formatted()
                selectedAddress?.latitude = selectedCoordinates.latitude.formatted()
            }
        } else if let fetchedAddress {
            let address = fetchedAddress.lines?.joined(separator: " ")
            selectedAddress = PickeyAddress(name: nil,
                                            isPrimary: 0,
                                            address: address,
                                            city: fetchedAddress.locality,
                                            state: fetchedAddress.administrativeArea,
                                            postalCode: fetchedAddress.postalCode,
                                            latitude: fetchedAddress.coordinate.latitude.formatted(),
                                            longitude: fetchedAddress.coordinate.longitude.formatted(),
                                            type: 1)
        }
        selectedAddress?.name = addressName
        return selectedAddress
    }
}
