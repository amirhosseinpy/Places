//
//  Statable.swift
//  Places
//
//  Created by Amirhossein Validabadi on 04/04/2025.
//

protocol Statable {}

enum DefaultViewState<T>: Statable {
  case loading
  case failure(error: Error)
  case success(T)
}
