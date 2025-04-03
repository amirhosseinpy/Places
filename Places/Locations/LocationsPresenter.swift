//
//  LocationsPresenter.swift
//  Wikipedia Places
//
//  Created by Amirhossein Validabadi on 03/04/2025.
//
import Combine
import Foundation

@MainActor
class LocationsPresenter: ObservableObject {
  @Published var state: LocationsState = .loading
  
  private let interactor: LocationsInteractor
  
  init(interactor: LocationsInteractor = LocationsInteractor()) {
    self.interactor = interactor
  }
  
  func loadLocations() {
    Task {
      do {
        var locations = try await interactor.getLocations()
        let locationsViewModel: [LocationModel] = locations.map { location in
          return LocationModel(id: UUID().uuidString, name: location.name ?? "Unknown", lat: location.lat, long: location.long)
        }
        state = .success(value: locationsViewModel)
      } catch {
        state = .failure(error: error)
      }
    }
  }
}

enum LocationsState {
  case loading
  case success(value: [LocationModel])
  case failure(error: Error)
}
