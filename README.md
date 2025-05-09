# ChronoPicker

<p align="leading">
    <img src="https://img.shields.io/badge/platform-iOS-blue.svg?style=flat" alt="Platforms" />
    <img src="https://img.shields.io/badge/Swift-5-orange.svg" />
    <a href="https://github.com/Kn3cht/ChronoPicker/blob/main/LICENSE"><img src="http://img.shields.io/badge/license-MIT-blue.svg?style=flat" alt="License: MIT" /></a>
</p>

[![SPM](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)
![Tests](https://github.com/Kn3cht/ChronoPicker/workflows/Swift/badge.svg)
[![Release](https://img.shields.io/github/v/release/Kn3cht/ChronoPicker)](https://img.shields.io/github/v/release/Kn3cht/ChronoPicker)



ChronoPicker is a highly customizable and lightweight SwiftUI date picker component designed for seamless integration into your iOS and macOS applications. With support for optionals, custom disabled dates, theming, and localization, ChronoPicker provides the flexibility you need to create a tailored user experience.

<img width="617" alt="image" src="https://github.com/user-attachments/assets/5ee0de1a-2a43-48ec-aaa9-2e6f92c71ccb">

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

If you are using a Package.swift, add `ChronoPicker` as following:

```swift
let package = Package(
  name: "Your Project Name",
  dependencies: [
    .package(url: "https://github.com/Kn3cht/ChronoPicker/releases", from: "<version>") // Checkout https://github.com/Kn3cht/ChronoPicker/releases
  ],
  ...
)
```

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

### Date Range Ricker
ChronoDatePicker has been updated to support date range selection, 
allowing users to choose a start and end date in addition to single-date selection. 
This enhancement makes it ideal for use cases like booking systems, scheduling, 
and other applications requiring date ranges.

```swift
import SwiftUI
import ChronoPicker

struct RangePickerExample: View {
    
    @State private var selectedDateRange: DateRange = DateRange(startDate: Date(), endDate: Calendar.current.date(byAdding: .day, value: 4, to: Date()))
    
    var body: some View {
        VStack {
            ChronoDatePicker($selectedDateRange)
            Text(selectedDateRange.description)
        }
    }
}
```

<img width="690" alt="image" src="https://github.com/user-attachments/assets/47242bfc-9332-4209-8591-f736488e1bb5" />


### Disabled Dates

ChronoPicker's `dateDisabled` callback function offers unparalleled flexibility compared to traditional range-based disabling. While ranges are sufficient for basic use cases, the callback function allows you to define complex, dynamic rules for disabling dates.

<img width="617" alt="image" src="https://github.com/user-attachments/assets/bb039d6b-6888-4588-bbd1-18edf3397494">

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

### More Examples

Checkout further examples [here](https://github.com/Kn3cht/ChronoPicker/tree/main/Example/ChronoPickerExample).

## Requirements

- iOS 15.0
- macOS 16.0
