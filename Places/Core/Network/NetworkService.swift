//
//  NetworkService.swift
//  Places
//
//  Created by Amirhossein Validabadi on 06/04/2025.
//
import Foundation

protocol NetworkServiceProtocol {
  func request<R: APIRouter, C: Decodable>(_ router: R) async throws -> C
}

actor NetworkService: NetworkServiceProtocol {
  private var decoder: JSONDecoder
  private var session: URLSession
  
  init(session: URLSession = URLSession.shared,
       decoder: JSONDecoder = JSONDecoder()
  ) {
    self.session = session
    self.decoder = decoder
  }
  
  func request<R: APIRouter, D: Decodable>(_ router: R) async throws -> D {
    guard let baseURL = router.baseURL else { throw URLError(.badURL) }
    var request = URLRequest(url: baseURL.appendingPathComponent(router.path))
    request.httpMethod = router.method.rawValue
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    // we can add token to the header here if needed
    let value: D = try await run(request)
    return value
  }
  
  private func run<D: Decodable>(_ request: URLRequest) async throws -> D {
    let (data, response) = try await session.data(for: request)
    // we can retry request here if needed
    try validate(response: response, data: data)
    let model: D = try self.decodeModel(data: data)
    // we can cache the model here if needed
    return model
  }
  
  private func validate(response: URLResponse?, data: Data?) throws {
    guard let response = response as? HTTPURLResponse, data != nil else { throw URLError(.badServerResponse) }
    
    switch response.statusCode {
    case 401:
      throw URLError(.userAuthenticationRequired)
    case 403:
      throw URLError(.cannotLoadFromNetwork)
    case 400...503:
        throw URLError(.badServerResponse)
      default:
        break
    }
  }
  
  private func decodeModel<D: Decodable>(data: Data) throws -> D {
    do {
      let model: D = try self.decoder.decode(D.self, from: data)
      return model
      
    } catch {
      throw URLError(.cannotDecodeContentData)
    }
  }
}

