//
//  LocationsInteractor.swift
//  Wikipedia Places
//
//  Created by Amirhossein Validabadi on 03/04/2025.
//

import Foundation

struct LocationsInteractor: LocationsInteractorProtocol {
  private let networkService: LocationsNetworkServiceProtocol
  
  init(networkService: LocationsNetworkServiceProtocol = LocationsNetworkService()) {
    self.networkService = networkService
  }
  
  func getLocations() async throws -> [LocationServerModel] {
    try await networkService.fetchLocations()
  }
  
  func getWikipediaURL(for location: LocationModel) -> URL? {
    var components = URLComponents()
    components.scheme = "wikipedia"
    components.host = "places"
    components.queryItems = [
      URLQueryItem(name: "lat", value: "\(location.lat)"),
      URLQueryItem(name: "lon", value: "\(location.long)"),
    ]
    return components.url
  }
}

protocol LocationsInteractorProtocol {
  func getLocations() async throws -> [LocationServerModel]
  func getWikipediaURL(for location: LocationModel) -> URL?
}
