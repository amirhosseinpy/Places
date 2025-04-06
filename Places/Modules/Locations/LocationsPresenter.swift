//
//  LocationsPresenter.swift
//  Wikipedia Places
//
//  Created by Amirhossein Validabadi on 03/04/2025.
//
import Combine
import UIKit


class LocationsPresenter: Presentable, ObservableObject {
  @MainActor @Published var state: DefaultViewState<[LocationModel]> = .loading
  private let interactor: LocationsInteractorProtocol
  private let urlService: URLServiceProtocol
  
  init(interactor: LocationsInteractorProtocol = LocationsInteractor(), urlService: URLServiceProtocol = URLService()) {
    self.interactor = interactor
    self.urlService = urlService
  }
  
  @MainActor
  func fetchData() {
    Task {
      do {
        let locations = try await interactor.getLocations()
        let locationsViewModel: [LocationModel] = locations.map { location in
          return LocationModel(id: UUID().uuidString, name: location.name ?? "Unknown", lat: location.lat, long: location.long)
        }
        state = .success(locationsViewModel)
      } catch {
        state = .failure(error: error)
      }
    }
  }
  
  // Handle the tap event for the location
  
  @MainActor
  func didTapLocation(location: LocationModel) {
    didSetCustomLocation(lat: location.lat, lon: location.long)
  }
  
  @MainActor
  func didSetCustomLocation(lat: Double, lon: Double) {
    guard let url = interactor.getWikipediaURL(lat: lat, lon: lon) else { return }
    // Open the Wikipedia URL in the app if possible
    if urlService.canOpen(url: url) {
      urlService.open(url:url)
    } else {
      state = .failure(error: URLError(.badURL))
    }
  }
}
