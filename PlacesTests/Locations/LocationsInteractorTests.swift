//
//  LocationsInteractorTests.swift
//  Places
//
//  Created by Amirhossein Validabadi on 06/04/2025.
//

import XCTest
@testable import Places

final class LocationsInteractorTests: XCTestCase {
  private var sut: LocationsInteractor!
  private var mockNetworkService: MockNetworkService!
  
  override func setUp() {
    super.setUp()
    mockNetworkService = MockNetworkService()
    sut = LocationsInteractor(networkService: mockNetworkService)
  }
  
  override func tearDown() {
    sut = nil
    mockNetworkService = nil
    super.tearDown()
  }
  
  func test_getLocations_success() async throws {
    // Given
    let response = LocationsAPIRouter.ResponseType(locations: [
      LocationServerModel.stub(name: "Test", lat: 51.5074, long: -0.1278)
    ])
    mockNetworkService.result = .success(response)
    
    // When
    let locations = try await sut.getLocations()
    
    // Then
    XCTAssertTrue(mockNetworkService.requestCalled)
    XCTAssertEqual(locations.count, 1)
    XCTAssertEqual(locations.first?.name, "Test")
    XCTAssertEqual(locations.first?.lat, 51.5074)
    XCTAssertEqual(locations.first?.long, -0.1278)
  }
  
  func test_getLocations_badServerResponse() async {
    // Given
    mockNetworkService.result = .failure(URLError(.badServerResponse))
    
    // When/Then
    do {
      _ = try await sut.getLocations()
      XCTFail("Expected badServerResponse error")
    } catch {
      XCTAssertEqual(error as? URLError, URLError(.badServerResponse))
    }
  }
  
  func test_getLocations_cannotDecodeContent() async {
    // Given
    mockNetworkService.result = .failure(URLError(.cannotDecodeContentData))
    
    // When/Then
    do {
      _ = try await sut.getLocations()
      XCTFail("Expected cannotDecodeContentData error")
    } catch {
      XCTAssertEqual(error as? URLError, URLError(.cannotDecodeContentData))
    }
  }
  
  func test_getLocations_badURL() async {
    // Given
    mockNetworkService.result = .failure(URLError(.badURL))
    
    // When/Then
    do {
      _ = try await sut.getLocations()
      XCTFail("Expected badURL error")
    } catch {
      XCTAssertEqual(error as? URLError, URLError(.badURL))
    }
  }
  
  func test_getLocations_emptyData() async {
    // Given
    let response = LocationsAPIRouter.ResponseType(locations: [])
    mockNetworkService.result = .success(response)
    
    // When
    let locations = try? await sut.getLocations()
    
    // Then
    XCTAssertTrue(mockNetworkService.requestCalled)
    XCTAssertEqual(locations?.count, 0)
  }
  
  func test_getWikipediaURL_returnsValidURL() {
    // Given
    let location = LocationModel.stub(id: "test", name: "Test", lat: 51.5074, long: -0.1278)
    
    // When
    guard let url = sut.getWikipediaURL(lat: location.lat, lon: location.long) else {
      XCTFail("Expected a valid URL")
      return
    }
    
    let component = URLComponents(string: url.absoluteString)
    
    // Then
    XCTAssertNotNil(component?.url)
    XCTAssertEqual(component?.scheme, "wikipedia")
    XCTAssertEqual(component?.host, "places")
    XCTAssertEqual(component?.queryItems?.count, 2)
    XCTAssertEqual(component?.queryItems?[0].name, "lat")
    XCTAssertEqual(component?.queryItems?[0].value, "51.5074")
    XCTAssertEqual(component?.queryItems?[1].name, "lon")
    XCTAssertEqual(component?.queryItems?[1].value, "-0.1278")
  }
}
