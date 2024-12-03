# ChronoPicker

<p align="leading">
    <img src="https://img.shields.io/badge/platform-iOS-blue.svg?style=flat" alt="Platforms" />
    <img src="https://img.shields.io/badge/Swift-5-orange.svg" />
    <a href="https://github.com/Kn3cht/ChronoPicker/blob/main/LICENSE"><img src="http://img.shields.io/badge/license-MIT-blue.svg?style=flat" alt="License: MIT" /></a>
</p>

[![SPM](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)
![Tests](https://github.com/Kn3cht/ChronoPicker/actions/workflows/Swift/badge.svg)
[![Release](https://img.shields.io/github/v/release/Kn3cht/ChronoPicker)](https://github.com/Kn3cht/ChronoPicker/releases)



ChronoPicker is a highly customizable and lightweight SwiftUI date picker component designed for seamless integration into your iOS and macOS applications. With support for optionals, custom disabled dates, theming, and localization, ChronoPicker provides the flexibility you need to create a tailored user experience.

## Features
- 🛠 Custom Disabled Dates: Disable specific dates or ranges based on your business logic, perfect for blackout periods, holidays, or availability constraints.
- 🎨 Customizability: Fully customize the appearance, including colors, fonts, and styles, to seamlessly match your app's design.
- 🌍 Localization: Built-in support for multiple languages, adapting automatically to the user's locale and calendar settings.

## Installation
Add ChronoPicker to your project using Swift Package Manager (SPM):

1. Open your Xcode project.
2. Go to File > Add Packages.
3. Enter the repository URL:
```
https://github.com/yourusername/ChronoPicker
```

4. Select the version or branch you'd like to use.

## Usage

ChronoPicker is designed with a usage pattern inspired by SwiftUI's standard DatePicker. However, unlike the standard DatePicker, ChronoPicker allows the selected date to be nil. This makes it ideal for scenarios where selecting a date is optional, such as forms or filters.

### Basic Example

```swift
import SwiftUI
import ChronoPicker

struct ContentView: View {
    @State private var selectedDate: Date? = Date()

    var body: some View {
        ChronoPicker($selectedDate)
            .padding()
    }
}
```

### Disabled Dates

ChronoPicker's `dateDisabled` callback function offers unparalleled flexibility compared to traditional range-based disabling. While ranges are sufficient for basic use cases, the callback function allows you to define complex, dynamic rules for disabling dates.

This approach ensures maximum flexibility, making ChronoPicker suitable for any scheduling or availability-related scenario.


```swift 

// Callback: Disable weekends
ChronoPicker(
    $selectedDate,
    dateDisabled: { date in
        Calendar.current.isDateInWeekend(date)
    }
)

// Range: Disable all dates after today
ChronoPicker(
    $selectedDate,
    in: ..<Date()
)
```

### Custom Date Rendering

ChronoPicker provides full flexibility for rendering dates by allowing you to override the default date view with your custom design. This feature is perfect for scenarios where you want to display additional information (e.g., events, availability) or apply unique styles to specific dates.

```swift
ChronoDatePicker(
    $selectedDate,
    customDateView: { date, selected, adjacent in
        // Your custom view
    })
```