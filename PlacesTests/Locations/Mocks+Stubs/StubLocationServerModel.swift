//
//  StubLocationServerModel.swift
//  Places
//
//  Created by Amirhossein Validabadi on 06/04/2025.
//
@testable import Places

extension LocationServerModel {
  static var stub: Self {
    return LocationServerModel(name: "Test", lat: 0, long: 0)
  }
  
  static func stub(name: String, lat: Double, long: Double) -> Self {
    return LocationServerModel(name: name, lat: lat, long: long)
  }
}
