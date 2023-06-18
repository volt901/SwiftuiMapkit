//
//  ResultModel.swift
//  SwiftuiMapkit
//
//  Created by Владимир Ширяев on 18.06.2023.
//

import Foundation
import MapKit

struct Place: Identifiable {
    var id: UUID = UUID()
    var name: String
    var placemark: MKPlacemark
    var coordinate: CLLocationCoordinate2D
    var adress: String?
}
