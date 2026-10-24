<img width="3340" height="2200" alt="Image" src="https://github.com/user-attachments/assets/a62e00e4-66f6-4bf9-901b-2401e808574f" />

Locavio is a robust and intuitive mobile application designed exclusively for property owners who prioritize convenience and efficient management. It centralizes the entire lifecycle of property management right in the palm of your hand, offering comprehensive tools to track expenses and profit reports, register tenants, securely archive digital contracts, and store vital property inspection photos—all within a single, streamlined platform. Built with a focus on user privacy and data security, Locavio leverages Apple's ecosystem, including iCloud and CloudKit, to ensure your data is always safe and synchronized, adhering strictly to the Brazilian General Data Protection Law (LGPD).

![Swift](https://img.shields.io/badge/Swift-FA7343?style=for-the-badge&logo=swift&logoColor=white) ![SwiftUI](https://img.shields.io/badge/SwiftUI-007AFF?style=for-the-badge&logo=swift&logoColor=white) ![iOS](https://img.shields.io/badge/iOS-000000?style=for-the-badge&logo=ios&logoColor=white) ![Apple Sign In](https://img.shields.io/badge/Apple_Sign_In-080808?style=for-the-badge&logo=apple&logoColor=white) ![iCloud](https://img.shields.io/badge/iCloud-3694F6?style=for-the-badge&logo=icloud&logoColor=white)


## App Store Screenshots Showcase

<p align="center">
  <img src="https://github.com/user-attachments/assets/55f7267c-2308-47af-9bb0-23dba95236ef" width="24%" />
  <img src="https://github.com/user-attachments/assets/6d3a388a-9e9c-416d-bd6e-4bd5fafcc39b" width="24%" />
  <img src="https://github.com/user-attachments/assets/053acf4d-768f-4ec6-831f-59a45746ea87" width="24%" />
  <img src="https://github.com/user-attachments/assets/47f10d7f-2a16-42e6-b5d4-e68f5ec3673e" width="24%" />

  <p align="center">
    <a target="_blank" href="https://apps.apple.com/br/app/locavio/id6813623367?l=en-GB">
      <img src="https://developer.apple.com/assets/elements/badges/download-on-the-app-store.svg" alt="Download on the App Store" width="180"/>
    </a>
  </p>
</p>

## Table of Contents

*   [Features](#features)
*   [Tech Stack](#tech-stack)
*   [Installation](#installation)
*   [Usage & How to Use](#usage--how-to-use)
    *   [User Flow](#user-flow)
    *   [Key Modules](#key-modules)
*   [Project Structure](#-project-structure)
*   [API Reference](#api-reference)
*   [License](#license)
*   [Important Links](#important-links)
*   [Contact](#thank-you-apple-developer-academy-)
*   [Agreements](#thank-you-apple-developer-academy-)

## Features

Locavio provides a rich set of features tailored for comprehensive property management:

*   **Property Profiles**: Create and maintain detailed profiles for each property, including address with intelligent autocomplete powered by ViaCEP, area, and photos.
*   **Tenant Management**: Register and manage tenant information, including names, contact details (email, phone), and document numbers (CPF/CNPJ) with built-in validation.
*   **Financial Tracking**: Keep a close eye on your finances by recording rental profits and managing associated property expenses. Visualize financial performance through intuitive reports.
*   **Digital Contract Archiving**: Securely upload and store digital copies of lease agreements and other important documents directly within the application, viewable with a built-in PDF viewer.
*   **Property Inspection Photos**: Store and categorize property inspection photos, providing a visual record of property conditions.
*   **Maintenance Request System (Tickets)**: Efficiently create, track, and manage maintenance tickets. Assign titles, detailed descriptions, set conclusion dates, and log associated maintenance costs.
*   **Interactive Dashboard & Reporting**: Gain insights into your properties' financial health with a dynamic dashboard displaying profit and expense reports over customizable periods (1 month, 6 months, 1 year). Track received vs. outstanding rent at a glance.
*   **Calendar View**: A dedicated calendar section to view upcoming payment due dates and maintenance ticket deadlines.
*   **Smart Notifications**: Receive timely push notifications for impending rent due dates and critical maintenance ticket deadlines, ensuring you never miss an important event.
*   **Secure User Authentication**: Seamless and secure sign-in experience using Apple Sign-In, enhancing user privacy and convenience.
*   **iCloud Synchronization**: All your property data, tenant information, financial records, and documents are securely stored and synchronized across your Apple devices via iCloud and CloudKit.
*   **Onboarding Experience**: A guided onboarding process for new users to introduce them to the application's core functionalities.

## Tech Stack

Locavio is built on Apple's modern development ecosystem, ensuring a native, performant, and secure experience:

*   **Primary Language**: Swift
*   **User Interface**: SwiftUI
*   **Data Persistence**: SwiftData (leveraging Core Data and CloudKit for iCloud sync)
*   **Architecture**: MVVM-C (Model-View-ViewModel with Coordinators) and Feature-Based Architecture
*   **Authentication**: `AuthenticationServices` (Apple Sign-In)
*   **In-App Guidance**: TipKit
*   **Multimedia**: AVFoundation (for splash screen video/audio), PDFKit (for document viewing)
*   **Notifications**: `UserNotifications`
*   **Networking**: `URLSession` for external API integration
*   **Utilities**: UIKit (for keyboard dismissal and image luminance calculation)
*   **External APIs**: ViaCEP (for Brazilian address autocomplete)

## Installation

Locavio is an iOS application. To set up and run the project locally, follow these steps:

1.  **Clone the repository**:
    ```bash
    git clone https://github.com/MrSampaio/Locavio.git
    cd Locavio
    ```

2.  **Open in Xcode**:
    Open the `locavio.xcodeproj` file using Xcode.
    ```bash
    open locavio.xcodeproj
    ```

3.  **Build and Run**: 
    Select a simulator or a connected physical iOS device (iPhone) and click the "Run" button in Xcode. Xcode will automatically handle the SwiftData model configuration and integrate with iCloud if your device is signed in with an Apple ID and CloudKit is enabled for the app.

## Usage & How to Use

Locavio simplifies property management through an intuitive interface. Here's a typical user journey and an overview of the main modules:

### User Flow

1.  **Splash Screen & Onboarding**: Upon first launch, users will experience a brief splash animation, followed by an interactive onboarding guide introducing core features.
2.  **Login/Registration**: Users sign in securely using **Apple Sign-In**. For new accounts, a quick registration step requires providing document details (CPF/CNPJ) to complete the profile.
3.  **Main Tab Navigation**: Once logged in, the app presents a tab bar at the bottom, offering easy navigation to five main sections:
    *   **Imóveis (Properties)**: Manage all your registered properties.
    *   **Relatório (Dashboard)**: View financial insights and reports.
    *   **Calendário (Calendar)**: Track important dates.
    *   **Chamados (Tickets)**: Handle maintenance requests.
    *   **Perfil (Profile)**: Manage personal settings and notification preferences.

### Key Modules

#### Property Management
*   Navigate to the **Imóveis** tab.
*   Tap the **"+"** button to add a new property. Fill in details like property name, area, and address. The address field utilizes the **ViaCEP API** for automatic completion, requiring only the CEP (ZIP code).
*   You can attach photos of the property and upload digital copies of lease contracts (PDFs) directly to the property profile.
*   Register tenants associated with each property, providing their name, email, CPF/CNPJ, and phone number.

#### Financial Overview
*   Go to the **Relatório (Dashboard)** tab.
*   Use the segmented control to switch between **"Lucro" (Profit)** and **"Despesa" (Expense)** views.
*   Filter data by period (1 month, 6 months, 1 year) using the menu in the top right corner.
*   The dashboard visually represents your financial data through interactive charts and summaries, showing total sums, received rent count, and unreceived rent count.
*   Within a property's detail view, you can record rent payments and attach receipts (PDFs).

#### Maintenance Tickets
*   Access the **Chamados (Tickets)** tab.
*   Create new maintenance tickets by providing a title, a detailed description (e.g., "Leaky faucet in bathroom"), and a desired conclusion date.
*   Track the status of tickets (Open, Concluded) and add maintenance costs incurred.
*   Receive notifications as deadlines approach, ensuring timely resolution.

#### Profile & Settings
*   In the **Perfil (Profile)** tab, manage your personal details.
*   Customize your notification preferences to receive alerts for rent due dates and ticket deadlines.
*   Option to securely delete your account and all associated data, following LGPD guidelines.

## 📁 Project Structure

The project follows a clean, feature-based architecture combined with the MVVM-C pattern, organizing code logically by functionality and responsibility.

```
Locavio/
├── App/ (Main application entry point)
│   └── locavioApp.swift
├── Assets.xcassets/ (Image and color assets)
├── Core/
│   ├── Components/ (Reusable SwiftUI views)
│   ├── Extensions/ (Swift extensions for various utilities)
│   ├── Models/ (Core data models and enums)
│   ├── Services/ (Centralized services like authentication, networking, notifications)
│   └── Tips/ (TipKit definitions for in-app hints)
├── Features/ (Feature-specific modules)
│   ├── Authentication/
│   │   ├── ViewModels/
│   │   └── Views/
│   ├── Calendar/
│   │   ├── Coordinators/
│   │   ├── Models/
│   │   └── Views/
│   ├── Dashboard/
│   │   ├── Coordinators/
│   │   ├── Models/
│   │   ├── ViewModels/
│   │   └── Views/
│   ├── SplashScreen/
│   │   └── (Views and Managers for app launch)
│   └── ... (Other features like Properties, Profile, Tickets)
├── Legal/ (Legal documents HTML)
│   └── index.html
├── Resources/ (Non-image assets like sounds)
├── locavio.xcodeproj/ (Xcode project file and settings)
└── LICENSE
```

## API Reference

Locavio integrates with a key external API to enhance property management functionality:

### ViaCEP API

*   **Description**: Used for automatically fetching address details (street, neighborhood, city, state) based on a provided Brazilian postal code (CEP).
*   **Endpoint**: `https://viacep.com.br/ws/{CEP}/json/`
*   **Usage (Internal `ViaCEPService.swift`)**:
    ```swift
    static func fetchAdress(cep: String) async throws -> ViaCEPResponse {
        // ... logic to clean CEP and construct URL
        guard let url = URL(string: "https://viacep.com.br/ws/\(cleanCEP)/json/") else { /* handle error */ }
        let (data, response) = try await URLSession.shared.data(from: url)
        // ... parse response
    }
    ```
*   **Data Protection**: The application transmits only the numeric CEP to the API to safeguard privacy, merging the generic information with sensitive property data only later and in encrypted form.

## License

This project is licensed under the **MIT License**. See the [LICENSE](LICENSE) file for more details.

## Important Links

*   **Legal Documents (Privacy Policy & Terms of Use)**: [https://mrsampaio.github.io/Locavio/Legal/](https://mrsampaio.github.io/Locavio/Legal/)
*   For any inquiries, feedback, or support, please reach out to: [locaviodev@gmail.com](mailto:locaviodev@gmail.com)

---

## Thank You, Apple Developer Academy 🍎

Locavio were Developed by [Emily Wojtowicz](https://www.linkedin.com/in/emily-wojtowicz-zacatei-nunes/), [MrSampaio](https://github.com/MrSampaio), [snowzinn1](https://github.com/snowzinn1), [AlexeyFrens](https://github.com/AlexeyFrens) and [mirellabransford](https://github.com/mirellabransford).

Reflact about it.



