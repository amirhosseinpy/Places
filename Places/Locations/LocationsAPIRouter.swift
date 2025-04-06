//
//  LocationsAPIRouter.swift
//  Places
//
//  Created by Amirhossein Validabadi on 06/04/2025.
//

struct LocationsAPIRouter: APIRouter {
  typealias ResponseType = LocationsResponse
  let method: HTTPMethod = .get
  var path: String
  
  init(path: String = "abnamrocoesd/assignment-ios/main/locations.json") {
    self.path = path
  }
}
    

