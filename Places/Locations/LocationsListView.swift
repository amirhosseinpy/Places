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
  
  var body: some View {
    NavigationView {
      content
        .navigationTitle("Locations")
        .task {
          presenter.fetchData()
        }
        .alert("Error", isPresented: .constant(isError)) {
          Button("Retry") {
            presenter.fetchData()
          }
          Button("OK", role: .cancel) { }
        } message: {
          Text(errorMessage)
        }
    }
  }
  
  @ViewBuilder
  private var content: some View {
    switch presenter.state {
    case .loading:
      ProgressView()
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
      }
    case .failure:
      Text("An error occurred.")
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
