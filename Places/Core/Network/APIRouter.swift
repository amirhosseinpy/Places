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
  static var method: HTTPMethod { get }
  static var baseURL: URL? { get }
  static var canRetry: Bool { get }
  
  var path: String { get }
  // We can have parameters for Post requests
}

extension APIRouter {
  public static var baseURL: URL? {
    return URL(string: "https://raw.githubusercontent.com/")
  }
}
