//
//  Untitled.swift
//  Places
//
//  Created by Amirhossein Validabadi on 06/04/2025.
//

//
//  MockURLService.swift
//  PlacesTests
//
//  Created by Amirhossein Validabadi on 05/04/2025.
//

import Foundation
@testable import Places

final class MockURLService: URLServiceProtocol {
    private(set) var openedURL: URL?
    private(set) var canOpenURLCallCount = 0
    private(set) var openURLCallCount = 0
    var canOpenURLResult = true

    func open(url: URL) {
        openURLCallCount += 1
        openedURL = url
    }

    func canOpen(url: URL) -> Bool {
        canOpenURLCallCount += 1
        return canOpenURLResult
    }
}
