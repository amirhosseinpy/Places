//
//  LocationsPresenter.swift
//  Wikipedia Places
//
//  Created by Amirhossein Validabadi on 03/04/2025.
//
import Combine
import UIKit

@MainActor
class LocationsPresenter: Presentable, ObservableObject {
  @Published var state: DefaultViewState<[LocationModel]> = .loading
  
  private let interactor: LocationsInteractorProtocol
  
  init(interactor: LocationsInteractorProtocol = LocationsInteractor()) {
    self.interactor = interactor
  }
  
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
  func didTapLocation(location: LocationModel) {
    guard let url = interactor.getWikipediaURL(for: location) else { return }
    let application = UIApplication.shared
    // Open the Wikipedia URL in the app if possible
    if application.canOpenURL(url) {
      application.open(url)
    } else {
     state = .failure(error: URLError(.badURL))
    }
  }
}
