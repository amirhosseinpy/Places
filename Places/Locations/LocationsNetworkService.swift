//
//  LocationsNetworkService.swift
//  Wikipedia Places
//
//  Created by Amirhossein Validabadi on 03/04/2025.
//

import Foundation

actor LocationsNetworkService: LocationsNetworkServiceProtocol {
  
  func fetchLocations() async throws -> [LocationServerModel] {
    let urlString = LocationsNetworkConstants.baseURL + LocationsNetworkConstants.locationsEndpoint
    guard let url = URL(string: urlString) else {
      throw URLError(.badURL)
    }
    
    let (data, _) = try await URLSession.shared.data(from: url)
    let response = try JSONDecoder().decode(LocationsResponse.self, from: data)
    return response.locations
  }
}

protocol LocationsNetworkServiceProtocol {
  func fetchLocations() async throws -> [LocationServerModel]
}

fileprivate enum LocationsNetworkConstants {
  static let baseURL = "https://raw.githubusercontent.com/"
  static let locationsEndpoint = "abnamrocoesd/assignment-ios/main/locations.json"
}
