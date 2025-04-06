//
//  URLService.swift
//  Places
//
//  Created by Amirhossein Validabadi on 05/04/2025.
//
import UIKit

protocol URLServiceProtocol {
  func open(url: URL)
  func canOpen(url: URL) -> Bool
}

class URLService: URLServiceProtocol {
  private let application = UIApplication.shared
  
  func open(url: URL) {
    application.open(url)
  }
  
  func canOpen(url: URL) -> Bool {
    application.canOpenURL(url)
  }
}
