# ChronicConnect iOS App

## Overview
ChronicConnect addresses a critical need in healthcare technology by creating supportive digital spaces for people living with chronic conditions who often face isolation and misunderstanding. The app provides a platform for users to connect, share experiences, and find support from others with similar health challenges.

## Features

- **Home Feed**: View and interact with posts from the community
  
<img width="357" alt="image" src="https://github.com/user-attachments/assets/f3f95a25-8d00-4c7b-b24a-9d6a6155db6a" />

- **Search**: Find users and content related to specific chronic conditions
  
<img width="343" alt="image" src="https://github.com/user-attachments/assets/ff2ba315-9324-4529-bc79-d9bb29fc41ca" />

- **Post Creation**: Share your experiences, questions, and insights
  
<img width="430" alt="image" src="https://github.com/user-attachments/assets/d3f7adbb-ef4d-412b-be3d-d1665874ed0a" />

- **Profile Management**: Customize your profile and manage your content

<img width="448" alt="image" src="https://github.com/user-attachments/assets/2cfbf641-106d-40ef-acb6-4634bb518af9" />

- **Condition Tags**: Tag posts with relevant chronic conditions for better discoverability
  
<img width="350" alt="image" src="https://github.com/user-attachments/assets/7e6df5cc-22ad-4d8d-a7f6-915fbea9dd37" />

- **Social Interactions**: Like, comment, and engage with community content

<img width="341" alt="image" src="https://github.com/user-attachments/assets/a6ae22d5-0d62-4530-b4be-9d27214cafff" />


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
   
## Functional Requirements

User Authentication

- User registration and login system
- Profile creation and management
- Privacy controls for sharing health information

Content Creation & Interaction

- Create and publish posts with text and media
- Comment on posts from other users
- Like/react to posts
- Share posts within the platform or externally
- Tag posts with specific chronic illness categories
- Follow other users with similar conditions

Search & Discovery

- Search for posts by illness tag, keywords, or user
- Discover trending topics in specific illness communities
- Filter content based on relevance to user's conditions

Optional AI Component

- Sentiment analysis of posts to identify support needs
- Content recommendations based on user interests/condition
- Automated moderation for supportive community guidelines

Non-Functional Requirements

- User-friendly interface designed for accessibility
- Performance optimized for smooth scrolling and interaction
- Secure handling of sensitive health information
- Offline capability for viewing previously loaded content


