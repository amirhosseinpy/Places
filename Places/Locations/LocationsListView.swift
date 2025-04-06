//
//  ContentView.swift
//  Wikipedia Places
//
//  Created by Amirhossein Validabadi on 03/04/2025.
//

// LocationsListView.swift
import SwiftUI

struct LocationsListView: View {
  @StateObject private var presenter = LocationsPresenter()
  @State private var showingLocationInput = false
  
  var body: some View {
    NavigationView {
      content
        .navigationTitle("Locations")
        .task {
          presenter.fetchData()
        }
        .navigationBarItems(trailing: Button(action: {
          showingLocationInput = true
        }) {
          Image(systemName: "location")
        })
        .accessibilityLabel("Check a location")
        .accessibilityHint("Opens form to enter coordinates")
        .sheet(isPresented: $showingLocationInput) {
          LocationInputView(isPresented: $showingLocationInput) { location in
            presenter.didSetCustomLocation(lat: location.lat, lon: location.lon)
          }
        }
        .alert("Error", isPresented: .constant(isError)) {
          Button("Retry") {
            presenter.fetchData()
          }
          .accessibilityLabel("Retry loading locations")
          Button("OK", role: .cancel) { }
            .accessibilityLabel("Dismiss error")
        } message: {
          Text(errorMessage)
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Locations List")
    }
  }
  
  @ViewBuilder
  private var content: some View {
    switch presenter.state {
    case .loading:
      ProgressView()
        .accessibilityLabel("Loading locations")
    case .success(let locations):
      List(locations) { location in
        HStack {
          Text(location.name)
            .font(.headline)
          Spacer()
        }
        .contentShape(Rectangle())
        .onTapGesture {
          presenter.didTapLocation(location: location)
        }
        .accessibilityElement(children: .combine)
        .font(.headline)
        .accessibilityLabel("Location: \(location.name)")
        .accessibilityHint("Tap to view on Wikipedia")
        .accessibilityAddTraits(.isButton)
      }
      .accessibilityLabel("Locations list")
      .accessibilityHint("Shows all available locations")
    case .failure:
      Text("An error occurred.")
        .accessibilityLabel("Error loading locations")
        .accessibilityAddTraits(.isStaticText)
    }
  }
  
  private var isError: Bool {
    if case .failure = presenter.state {
      return true
    }
    return false
  }
  
  private var errorMessage: String {
    if case .failure(let error) = presenter.state {
      return error.localizedDescription
    }
    return "Unknown error"
  }
}

#Preview {
  LocationsListView()
}
