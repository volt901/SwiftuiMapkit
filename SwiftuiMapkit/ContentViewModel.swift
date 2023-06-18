//
//  ContentViewModel.swift
//  SwiftuiMapkit
//
//  Created by Владимир Ширяев on 18.06.2023.
//

import Foundation
import MapKit

class ContentViewModel: NSObject, ObservableObject, CLLocationManagerDelegate  {
    
    var locationManager: CLLocationManager?
    var searchTerm = ""
    
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
    
    @Published var places = [Place]()
    @Published var selectedPlace: Place?
    
    var selectedPlaceName: String {
        guard let selectPlace = selectedPlace else {return ""}
        return selectPlace.name
    }
    
    var selectedPlaceAdress: String {
        guard let selectPlace = selectedPlace else {return ""}
        if let street = selectPlace.placemark.thoroughfare,
           let subAdress = selectPlace.placemark.subThoroughfare {
            return street + "," + subAdress
        }
        return ""
    }
    
    // 1 -  проверить доступ к локации
    func checkLocationIsEnable(){
        if CLLocationManager.locationServicesEnabled(){
            locationManager = CLLocationManager()
            locationManager?.delegate = self
        } else {
            print("alert")
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuth()
    }
    
    
    // 2 - проверка прав
    
    func checkLocationAuth(){
        guard let locationManager = locationManager else {return}
        switch locationManager.authorizationStatus {
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print ("ограничения")
        case .denied:
            print ("доступ не предоставлен")
        case .authorizedAlways, .authorizedWhenInUse:
            //locationManager.location!.coordinate
           
            region = MKCoordinateRegion(center: locationManager.location!.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        @unknown default:
            break
        }
        
    }
    // 3 - функци поиск
    func serch(){
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchTerm
        request.region = region
        
        let search = MKLocalSearch(request: request)
        search.start { responce, err in
            guard let responce = responce else {return}
            
            DispatchQueue.main.async{
                self.places = responce.mapItems.map({ item in
                    Place(name: item.name ?? "", placemark: item.placemark, coordinate: item.placemark.coordinate, adress: item.placemark.locality)
                })
            }
        }
    }
    

    // 4 - функция выбора
    func selectedPlace(for place: Place){
        self.selectedPlace = place
    }
}
