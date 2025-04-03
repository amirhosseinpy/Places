//
//  LocationsNetworkService.swift
//  Wikipedia Places
//
//  Created by Amirhossein Validabadi on 03/04/2025.
//

import Foundation

actor LocationsNetworkService {
  private let urlString = "https://raw.githubusercontent.com/abnamrocoesd/assignment-ios/main/locations.json"
  
  func fetchLocations() async throws -> [LocationServerModel] {
    guard let url = URL(string: urlString) else {
      throw URLError(.badURL)
    }
    
    let (data, _) = try await URLSession.shared.data(from: url)
    let response = try JSONDecoder().decode(LocationsResponse.self, from: data)
    return response.locations
  }
}
