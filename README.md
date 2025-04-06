# Places App

A SwiftUI-based iOS application that fetches location data from an API and enables users to explore Wikipedia articles based on coordinates.

## Features

- Display server-fetched locations
- Custom coordinate input
- Wikipedia integration via custom URL scheme
- Full accessibility support
- Clean architecture with VIP pattern

## Requirements

- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+

## Architecture

The app follows VIP (View-Interactor-Presenter) pattern:
- Views: `LocationsListView`, `LocationInputView`
- Presenter: `LocationsPresenter`
- Interactor: `LocationsInteractor`
- Network Layer: `NetworkService`
- URL Handling: `URLService`

## Key Components

### LocationsInteractor
- Handles business logic and API communication
- Fetches locations from server via `NetworkService`
- Generates Wikipedia URLs for coordinates
- Protocol-based for testability

### LocationsPresenter
- Manages view state using `@Published` properties
- Converts server models to view models
- Handles location selection and URL opening
- Error handling and state management

### LocationsListView
- Displays fetched locations
- Shows loading and error states
- Custom location input via sheet
- Full VoiceOver support

### LocationInputView
- Coordinate input form
- Input validation
- Dismissible sheet presentation
- Accessibility labels and hints

## Setup

1. Clone the repository
2. Open `Places.xcodeproj` in Xcode
3. Build and run the project

## API Integration

The app expects the server to return locations in the following format:
```swift
struct LocationServerModel {
    let name: String?
    let lat: Double
    let long: Double
}
```
## Further Enhancement 
1. Add support for Caching and retry in network service
2. Make error messages user friendly
3. Add annotation for places called by this app in wikipedia app
