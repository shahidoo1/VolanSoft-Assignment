# flutter_application

## Overview
This is a Flutter application that allows users to view, search, and filter a list of user profiles fetched from a REST API. The app is built following the MVVM (Model-View-ViewModel) architecture pattern, leveraging Provider for state management and connectivity_plus for monitoring internet connectivity. This README provides instructions for setting up the app, details the key features, and explains the design decisions behind the project.

## Features
- **User List Display**: Fetches and displays a list of users from a remote API.
- **Search Functionality**: Allows users to search profiles by name and ZIP code.
- **Detailed User Profiles**: Provides detailed information on each user, including contact details, address, and company information.

- **Connectivity Awareness**: Automatically handles connectivity changes, showing appropriate error messages when the internet is unavailable.

- **Robust Error Handling**: Provides clear and user-friendly error messages for various failure scenarios, including failed API requests and empty search results.

## Architecture
### MVVM Pattern
The app is structured using the MVVM pattern to ensure separation of concerns and improve maintainability:

- **Model**: Contains the data classes (`User`, `Address`, `Company`) that represent the structure of the API response.

- **ViewModel**: Encapsulates the business logic and handles data fetching, filtering, and state management. The `UserViewModel` class is responsible for communicating with the API, storing user data, and applying search filters. It also manages the app's response to changes in internet connectivity.

- **View**: Comprises the UI components that present data to the user. The views listen to changes in the ViewModel and update the UI accordingly. The main screens include `HomeScreen` (for displaying the list of users) and `DetailScreen` (for showing detailed user information).

## Installation
### Prerequisites
- **Flutter**: Make sure you have Flutter installed. You can download it [here](https://flutter.dev/docs/get-started/install).
- **Git**: Ensure you have Git installed for cloning the repository.

## Usage
- **Search**: Use the search fields on the `HomeScreen` to filter users by name or ZIP code.
- **View Details**: Click on any user in the list to view their detailed profile, including their address and company information.
- **Connectivity**: The app automatically handles internet connectivity. If the connection is lost, an appropriate message will be displayed.

## Error Handling
- **Connectivity Issues**: Detects when the device is offline and informs the user with a clear message. Automatically attempts to fetch data when the connection is restored.
- **API Errors**: Handles failed API requests gracefully by displaying an error message to the user.
- **Empty Search Results**: Notifies the user if no profiles match their search criteria.

## Design Choices
- **MVVM Architecture**: The MVVM pattern was chosen for its scalability and separation of concerns, making it easier to manage, test, and extend the app.
- **State Management with Provider**: The Provider package is used for state management due to its simplicity and integration with Flutter's build system.
- **Real-time Connectivity Handling**: The connectivity_plus package is employed to monitor the device's network status in real-time, allowing the app to respond dynamically to changes in connectivity.
