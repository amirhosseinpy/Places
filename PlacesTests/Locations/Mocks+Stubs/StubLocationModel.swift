//
//  StubLocationModel.swift
//  Places
//
//  Created by Amirhossein Validabadi on 06/04/2025.
//

@testable import Places

extension LocationModel {
  static var stub: Self {
    return LocationModel(id: "1", name: "Test", lat: 0, long: 0)
  }
  
  static func stub(id: String, name: String, lat: Double, long: Double) -> Self {
    return LocationModel(id: id, name: name, lat: lat, long: long)
  }
}

