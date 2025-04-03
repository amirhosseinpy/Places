//
//  LocationsInteractor.swift
//  Wikipedia Places
//
//  Created by Amirhossein Validabadi on 03/04/2025.
//

import Foundation

actor LocationsInteractor {
  private let networkService: LocationsNetworkService
  
  init(networkService: LocationsNetworkService = LocationsNetworkService()) {
    self.networkService = networkService
  }
  
  func getLocations() async throws -> [LocationServerModel] {
    try await networkService.fetchLocations()
  }
}
