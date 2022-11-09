//
//  AddLocationViewController.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 03/11/2022.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation

protocol AddLocationDelegate: AnyObject {
    func locationAdded()
}

class AddLocationViewController: EditProfileBaseViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    private let maximumHeight: CGFloat = 350
    private var tableDataSource: GMSAutocompleteTableDataSource!
    
    let searchBar = UISearchBar(frame: .zero)
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var preciseLocationZoomLevel: Float = 15.0
    var approximateLocationZoomLevel: Float = 10.0
    var viewModel = AddressViewModel()
    weak var delegate: AddLocationDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 50
        self.locationManager.startUpdatingLocation()
        
        tableDataSource = GMSAutocompleteTableDataSource()
        tableDataSource.delegate = self
        tableDataSource.tableCellBackgroundColor = .black
        tableDataSource.primaryTextHighlightColor = .white
        tableDataSource.tableCellSeparatorColor = .lightGray
        tableDataSource.primaryTextColor = .lightGray
        
        tableView.delegate = tableDataSource
        tableView.dataSource = tableDataSource
        tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        tableView.isHidden = true
        
        self.addMap()
        self.addSerachBar()
        viewModel.delegate = self
        placesClient = GMSPlacesClient.shared()
    }
    
    func addSerachBar() {
        searchBar.delegate = self
        searchBar.barTintColor = .black
        searchBar.searchTextField.textColor = .white
        searchBar.searchTextField.placeholder = "Search"
        searchBar.searchTextField.addPaddingLeftIcon(UIImage(named: "searchIcon")!, padding: 0)
        searchBar.backgroundColor = .black
        searchBar.barStyle = .black
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchView.addSubview(searchBar)
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: searchView.topAnchor, constant: -16),
            searchBar.leftAnchor.constraint(equalTo: searchView.leftAnchor, constant: -12),
            searchBar.rightAnchor.constraint(equalTo: searchView.rightAnchor, constant: 6),
            searchBar.bottomAnchor.constraint(equalTo: searchView.bottomAnchor, constant: 16)
        ])
        addDoneButtonOnKeyboard()
    }
    
    func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.toolbarButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        searchBar.inputAccessoryView = doneToolbar
    }
    
    @objc func toolbarButtonAction(){
        searchBar.resignFirstResponder()
    }
    
    @IBAction func onclickDone() {
        let controller = AddAddressView(frame: .zero)
        controller.typeSelected = {[weak self] addressType in
            guard let self else {return}
            self.showLoader()
            self.viewModel.addressName = addressType.name
            self.viewModel.createAddress()
        }
        let vc = PickeySheet(view: controller)
        present(vc, animated: true)
    }
    
    func addMap() {
        // A default location to use when location permission is not granted.
        let defaultLocation = CLLocation(latitude: -33.869405, longitude: 151.199)

        // Create a map.
        let zoomLevel = locationManager.accuracyAuthorization == .fullAccuracy ? preciseLocationZoomLevel : approximateLocationZoomLevel
        let camera = GMSCameraPosition.camera(withLatitude: defaultLocation.coordinate.latitude,
                                              longitude: defaultLocation.coordinate.longitude,
                                              zoom: zoomLevel)
        mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.tag = 0xDEADBEEF
        mapView.delegate = self
        
        contentView.addSubview(mapView)
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mapView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            mapView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            mapView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    @IBAction func onclickBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if(keyPath == "contentSize"){
            if let newvalue = change?[.newKey]
            {
                let newsize  = newvalue as! CGSize
                tableViewHeight.constant = newsize.height < maximumHeight ? newsize.height : maximumHeight
            }
        }
    }
}

extension AddLocationViewController: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        moveMap(location.coordinate)
        
        let placeFields: GMSPlaceField = [.name, .coordinate]
        placesClient.findPlaceLikelihoodsFromCurrentLocation(withPlaceFields: placeFields) { (placeLikelihoods, error) in
            guard error == nil else {
                // TODO: Handle the error.
                print("Current Place error: \(error!.localizedDescription)")
                return
            }
            
            guard let placeLikelihoods = placeLikelihoods else {
                print("No places found.")
                return
            }
            
            self.addMarkerToPlace(placeLikelihoods.first?.place, location.coordinate)
        }
    }
    
    func moveMap(_ coordinate: CLLocationCoordinate2D) {
        let zoomLevel = locationManager.accuracyAuthorization == .fullAccuracy ? preciseLocationZoomLevel : approximateLocationZoomLevel
        let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude,
                                              longitude: coordinate.longitude,
                                              zoom: zoomLevel)
        mapView.animate(to: camera)
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // Check accuracy authorization
        let accuracy = manager.accuracyAuthorization
        switch accuracy {
        case .fullAccuracy:
            print("Location accuracy is precise.")
        case .reducedAccuracy:
            print("Location accuracy is not precise.")
        @unknown default:
            fatalError()
        }
        
        // Handle authorization status
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status granted.")
        @unknown default:
            fatalError()
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
    
    func addMarkerToPlace(_ place: GMSPlace?, _ coordinate: CLLocationCoordinate2D? = nil) {
        mapView.clear()
        guard let place else {return}
        let marker = GMSMarker(position: coordinate ?? place.coordinate)
        marker.title = place.name
        marker.snippet = place.formattedAddress
        marker.isDraggable = true
        marker.map = mapView
        viewModel.seletedPlace = place
        viewModel.selectedCoordinates = coordinate
        viewModel.fetchedAddress = nil
    }
    
}

extension AddLocationViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Update the GMSAutocompleteTableDataSource with the search text.
        tableView.isHidden = searchText.isEmpty
        tableDataSource.sourceTextHasChanged(searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension AddLocationViewController: GMSAutocompleteTableDataSourceDelegate {
    func didUpdateAutocompletePredictions(for tableDataSource: GMSAutocompleteTableDataSource) {
        // Reload table data.
        tableView.reloadData()
    }
    
    func didRequestAutocompletePredictions(for tableDataSource: GMSAutocompleteTableDataSource) {
        // Reload table data.
        tableView.reloadData()
    }
    
    func tableDataSource(_ tableDataSource: GMSAutocompleteTableDataSource, didAutocompleteWith place: GMSPlace) {
        // Do something with the selected place.
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
        moveMap(place.coordinate)
        addMarkerToPlace(place)
    }
    
    func tableDataSource(_ tableDataSource: GMSAutocompleteTableDataSource, didFailAutocompleteWithError error: Error) {
        // Handle the error.
        tableView.isHidden = true
        print("Error: \(error.localizedDescription)")
    }
    
    func tableDataSource(_ tableDataSource: GMSAutocompleteTableDataSource, didSelect prediction: GMSAutocompletePrediction) -> Bool {
        tableView.isHidden = true
        return true
    }
}

extension AddLocationViewController: GMSMapViewDelegate {
    
    //MARK - GMSMarker Dragging
    func mapView(_ mapView: GMSMapView, didBeginDragging marker: GMSMarker) {
        print("didBeginDragging")
    }
    func mapView(_ mapView: GMSMapView, didDrag marker: GMSMarker) {
        print("didDrag")
    }
    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
        print(marker)
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(marker.position) { response, error in
            if error != nil {
                print("reverse geodcode fail: \(error!.localizedDescription)")
            } else {
                if let place = response?.firstResult() {
                    self.viewModel.fetchedAddress = place
                    self.viewModel.seletedPlace = nil
                    self.viewModel.selectedCoordinates = nil
                } else {
                    print("GEOCODE: nil in places")
                }
            }
        }
    }
}

extension AddLocationViewController: ProfileDelegate {
    func addressCreated() {
        DispatchQueue.main.async {
            self.removeLoader()
            self.delegate?.locationAdded()
            self.navigationController?.popViewController(animated: true)
        }
    }
}
