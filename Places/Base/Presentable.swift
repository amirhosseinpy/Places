//
//  Presentable.swift
//  Places
//
//  Created by Amirhossein Validabadi on 04/04/2025.
//


protocol Presentable: AnyObject {
  associatedtype State: Statable
  @MainActor var state: State { get }
  @MainActor func fetchData()
}
