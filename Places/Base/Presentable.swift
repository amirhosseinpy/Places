//
//  Presentable.swift
//  Places
//
//  Created by Amirhossein Validabadi on 04/04/2025.
//

@MainActor
protocol Presentable: AnyObject {
  associatedtype State: Statable
  var state: State { get }
  func fetchData()
}
