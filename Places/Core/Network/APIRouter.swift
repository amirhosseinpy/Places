//
//  APIRouter.swift
//  Places
//
//  Created by Amirhossein Validabadi on 06/04/2025.
//

import UIKit

public enum HTTPMethod: String, Encodable {
  case get = "GET"
}

protocol APIRouter {
  associatedtype ResponseType: Codable
  var method: HTTPMethod { get }
  var baseURL: URL? { get }
  
  var path: String { get }
  // We can have parameters for Post requests
}

extension APIRouter {
  var baseURL: URL? {
    return URL(string: "https://raw.githubusercontent.com/")
  }
}
