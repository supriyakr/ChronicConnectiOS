# ChronicConnect iOS App

## Overview
ChronicConnect addresses a critical need in healthcare technology by creating supportive digital spaces for people living with chronic conditions who often face isolation and misunderstanding. The app provides a platform for users to connect, share experiences, and find support from others with similar health challenges.

## Features

- **Home Feed**: View and interact with posts from the community
- **Search**: Find users and content related to specific chronic conditions
- **Post Creation**: Share your experiences, questions, and insights
- **Profile Management**: Customize your profile and manage your content
- **Condition Tags**: Tag posts with relevant chronic conditions for better discoverability
- **Social Interactions**: Like, comment, and engage with community content

## Technical Details

- **Platform**: iOS
- **Framework**: SwiftUI
- **Data Persistence**: Core Data
- **Architecture**: MVVM (Model-View-ViewModel)
- **Minimum iOS Version**: iOS 16.0+

## Getting Started

### Prerequisites
- Xcode 15.0+
- iOS 16.0+ device or simulator

### Installation
1. Clone the repository
   ```bash
   git clone [repository-url]
   cd ChronicConnectiOS
   ```
2. Open the project in Xcode
   ```bash
   open ChronicConnect.xcodeproj
   ```
3. Build and run the application on your device or simulator

## Project Structure

- **ChronicConnectApp.swift**: Main app entry point
- **ContentView.swift**: Main container view with tab navigation
- **Core/**: Core functionality and utilities
- **Features/**: Feature modules organized by functionality
  - HomeFeed/: Home feed implementation
  - PostCreation/: Post creation functionality
  - Profile/: User profile management
  - Search/: Search functionality
- **Models/**: Data models and Core Data entities

## Development

### Sample Data
The app includes sample data generation for development and testing purposes. This is enabled in DEBUG mode only.

### Adding New Features
When adding new features:
1. Create a new directory under the Features/ folder
2. Follow the MVVM pattern with separate View and ViewModel files
3. Add any necessary models or extensions

## License

[Include license information here]

## Contact

[Your contact information or project team contact]
