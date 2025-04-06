//
//  Untitled.swift
//  Places
//
//  Created by Amirhossein Validabadi on 06/04/2025.
//

import SwiftUI

struct LocationInputView: View {
  @Environment(\.dismiss) var dismiss
  @Binding var isPresented: Bool
  @State private var latitude: String = ""
  @State private var longitude: String = ""
  var onLocationSubmit: ((lat: Double, lon: Double)) -> Void
  
  var body: some View {
    NavigationView {
      Form {
        Section {
          TextField("Latitude", text: $latitude)
            .keyboardType(.decimalPad)
            .accessibilityLabel("Enter latitude")
            .accessibilityHint("Enter a decimal number for latitude")
          TextField("Longitude", text: $longitude)
            .keyboardType(.decimalPad)
            .accessibilityLabel("Enter longitude")
            .accessibilityHint("Enter a decimal number for longitude")
        }
      }
      .navigationTitle("Enter Location")
      .navigationBarItems(
        leading: Button("Cancel") {
          dismiss()
        }
          .accessibilityLabel("Cancel location input"),
        trailing: Button("Submit") {
          if let lat = Double(latitude), let lon = Double(longitude) {
            // Handle the coordinates here
            onLocationSubmit((lat, lon))
            print("Latitude: \(lat), Longitude: \(lon)")
            dismiss()
          }
        }
          .accessibilityLabel("Submit location")
          .accessibilityHint("Save the entered coordinates")
      )
    }
    .accessibilityElement(children: .contain)
  }
}
