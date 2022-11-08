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
    
    var selectedAddress: PickeyAddress?
    var seletedPlace: GMSPlace?
    var fetchedAddress: GMSAddress?
    var selectedCoordinates: CLLocationCoordinate2D?
}
