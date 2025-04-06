//
//  MockLocationsInteractor.swift
//  Places
//
//  Created by Amirhossein Validabadi on 04/04/2025.
//

import Foundation
@testable import Places

final class MockLocationsInteractor: LocationsInteractorProtocol {
  var mockLocations: [LocationServerModel] = []
  var mockError: Error?
  var wikipediaURL: URL?
  var lastLatitude: Double?
  var lastLongitude: Double?
  var getWikipediaURLCallCount = 0
  
  func getLocations() async throws -> [LocationServerModel] {
    if let mockError = mockError {
      throw mockError
    }
    return mockLocations
  }
  
  func getWikipediaURL(lat: Double, lon: Double) -> URL? {
    getWikipediaURLCallCount += 1
    lastLatitude = lat
    lastLongitude = lon
    return wikipediaURL
  }
}
