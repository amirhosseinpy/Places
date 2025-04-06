//
//  LocationsPresenterTests.swift
//  Places
//
//  Created by Amirhossein Validabadi on 04/04/2025.
//

import XCTest
import Combine
@testable import Places

final class LocationsPresenterTests: XCTestCase {
  private var sut: LocationsPresenter!
  private var mockInteractor: MockLocationsInteractor!
  private var mockURLService: MockURLService!
  private var cancellables: Set<AnyCancellable>!
  
  override func setUp() {
    super.setUp()
    mockInteractor = MockLocationsInteractor()
    mockURLService = MockURLService()
    sut = LocationsPresenter(interactor: mockInteractor, urlService: mockURLService)
    cancellables = []
  }
  
  override func tearDown() {
    sut = nil
    mockInteractor = nil
    mockURLService = nil
    cancellables = nil
    super.tearDown()
  }
  
  func test_fetchData_success() async {
    // Given
    let expectation = XCTestExpectation(description: "State should update")
    let expectedLocations = [LocationServerModel.stub]
    mockInteractor.mockLocations = expectedLocations
    
    sut.$state
      .dropFirst()
      .sink { state in
        // Then
        guard case .success(let locations) = state else {
          XCTFail("Expected success state")
          return
        }
        XCTAssertEqual(locations.count, 1)
        XCTAssertEqual(locations.first?.name, "Test")
        expectation.fulfill()
      }
      .store(in: &cancellables)
    // When
    await sut.fetchData()
    
    await fulfillment(of: [expectation], timeout: 1.0)
  }
  
  func test_fetchData_failure() async {
    // Given
    let expectation = XCTestExpectation(description: "State should update")
    mockInteractor.mockError = NSError(domain: "test", code: -1)
    
    sut.$state
      .dropFirst()
      .sink { state in
        // Then
        guard case .failure = state else {
          XCTFail("Expected failure state")
          return
        }
        expectation.fulfill()
      }
      .store(in: &cancellables)
    
    // When
    await sut.fetchData()
    
    await fulfillment(of: [expectation], timeout: 1.0)
  }
  
  func test_fetchData_emptyLocations() async {
    // Given
    let expectation = XCTestExpectation(description: "State should update with empty array")
    mockInteractor.mockLocations = []
    
    sut.$state
      .dropFirst()
      .sink { state in
        guard case .success(let locations) = state else {
          XCTFail("Expected success state with empty array")
          return
        }
        XCTAssertTrue(locations.isEmpty)
        expectation.fulfill()
      }
      .store(in: &cancellables)
    
    // When
    await sut.fetchData()
    
    await fulfillment(of: [expectation], timeout: 1.0)
  }
  
  func test_fetchData_multipleLocations() async {
    // Given
    let expectation = XCTestExpectation(description: "State should update with multiple locations")
    let locations = [
      LocationServerModel(name: "First", lat: 0, long: 0),
      LocationServerModel(name: "Second", lat: 1, long: 1)
    ]
    mockInteractor.mockLocations = locations
    
    sut.$state
      .dropFirst()
      .sink { state in
        guard case .success(let receivedLocations) = state else {
          XCTFail("Expected success state")
          return
        }
        XCTAssertEqual(receivedLocations.count, 2)
        XCTAssertEqual(receivedLocations[0].name, "First")
        XCTAssertEqual(receivedLocations[1].name, "Second")
        expectation.fulfill()
      }
      .store(in: &cancellables)
    
    // When
    await sut.fetchData()
    
    await fulfillment(of: [expectation], timeout: 1.0)
  }
  
  func test_fetchData_nullLocationName() async {
    // Given
    let expectation = XCTestExpectation(description: "State should update with unknown name")
    let locationWithNullName = LocationServerModel(name: nil, lat: 0, long: 0)
    mockInteractor.mockLocations = [locationWithNullName]
    
    sut.$state
      .dropFirst()
      .sink { state in
        guard case .success(let locations) = state else {
          XCTFail("Expected success state")
          return
        }
        XCTAssertEqual(locations.first?.name, "Unknown")
        expectation.fulfill()
      }
      .store(in: &cancellables)
    
    // When
    await sut.fetchData()
    
    await fulfillment(of: [expectation], timeout: 1.0)
  }
  
  func test_fetchData_networkError() async {
    // Given
    let expectation = XCTestExpectation(description: "State should update with network error")
    mockInteractor.mockError = URLError(.notConnectedToInternet)
    
    sut.$state
      .dropFirst()
      .sink { state in
        guard case .failure(let error) = state,
              let urlError = error as? URLError,
              urlError.code == .notConnectedToInternet else {
          XCTFail("Expected network error")
          return
        }
        expectation.fulfill()
      }
      .store(in: &cancellables)
    
    // When
    await sut.fetchData()
    
    await fulfillment(of: [expectation], timeout: 1.0)
  }
  
  func test_didTapLocation_opensURLSuccessfully() async {
    // Given
    let location = LocationModel.stub
    let mockURL = URL(string: "wikipedia://test")!
    mockInteractor.wikipediaURL = mockURL
    mockURLService.canOpenURLResult = true
    
    // When
    await sut.didTapLocation(location: location)
    
    // Then
    XCTAssertEqual(mockInteractor.getWikipediaURLCallCount, 1)
    XCTAssertEqual(mockURLService.canOpenURLCallCount, 1)
    XCTAssertEqual(mockURLService.openURLCallCount, 1)
  }
  
  func test_didTapLocation_cannotOpenURL() async {
      // Given
      let expectation = XCTestExpectation(description: "State should update to failure")
    let location = LocationModel.stub
      let mockURL = URL(string: "invalid://test")!
      mockInteractor.wikipediaURL = mockURL
      mockURLService.canOpenURLResult = false
      
      sut.$state
          .dropFirst()
          .sink { state in
              guard case .failure(let error) = state,
                    let urlError = error as? URLError,
                    urlError.code == .badURL else {
                  XCTFail("Expected URLError.badURL")
                  return
              }
              expectation.fulfill()
          }
          .store(in: &cancellables)
      
      // When
      await sut.didTapLocation(location: location)
      
      // Then
      XCTAssertEqual(mockURLService.canOpenURLCallCount, 1)
      XCTAssertEqual(mockURLService.openURLCallCount, 0)
      XCTAssertNil(mockURLService.openedURL)
      
      await fulfillment(of: [expectation], timeout: 1.0)
  }
  
  func test_didTapLocation_nilURL() async {
    // Given
    let location = LocationModel.stub
    mockInteractor.wikipediaURL = nil
    
    // When
    await sut.didTapLocation(location: location)
    
    // Then
    XCTAssertEqual(mockInteractor.getWikipediaURLCallCount, 1)
    XCTAssertEqual(mockURLService.canOpenURLCallCount, 0)
    XCTAssertEqual(mockURLService.openURLCallCount, 0)
  }
  
  func test_initialState_isLoading() async {
    // Then
    guard case .loading = await sut.state else {
      XCTFail("Initial state should be loading")
      return
    }
  }
}
