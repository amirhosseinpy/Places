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
}
