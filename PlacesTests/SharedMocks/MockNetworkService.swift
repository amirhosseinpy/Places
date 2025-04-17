//
//  MockNetworkService.swift
//  Places
//
//  Created by Amirhossein Validabadi on 06/04/2025.
//
import Foundation
@testable import Places

final class MockNetworkService: NetworkServiceProtocol {
    var result: Result<Any, Error> = .success([:])
    private(set) var requestCalled = false
    private(set) var lastRouter: Any?

    func request<R: APIRouter, C: Decodable>(_ router: R) async throws -> C {
        requestCalled = true
        lastRouter = router
        
        switch result {
        case .success(let data):
            guard let response = data as? C else {
                throw URLError(.cannotDecodeContentData)
            }
            return response
        case .failure(let error):
            throw error
        }
    }
}
