//
//  LocationModel.swift
//  Wikipedia Places
//
//  Created by Amirhossein Validabadi on 03/04/2025.
//

import Foundation

struct LocationServerModel: Codable {
  let name: String?
  let lat: Double
  let long: Double
}

struct LocationsResponse: Codable {
  let locations: [LocationServerModel]
}

struct LocationModel: Codable, Identifiable {
  let id: String
  let name: String
  let lat: Double
  let long: Double
}
