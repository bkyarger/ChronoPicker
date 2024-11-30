//
//  MonthYearPicker.swift
//  ChronoPicker
//
//  Created by Gerald Mahlknecht on 30.11.24.
//

import SwiftUI

struct MonthYearPicker: View {
    
    @Binding var currentDate: Date
    private let calendar = Calendar.current
    private let months: [String]
    private var yearRange: ClosedRange<Int>

    init(currentDate: Binding<Date>, yearRange: ClosedRange<Int> = 1900...2200) {
        self._currentDate = currentDate

        // Generate month names using the calendar
        self.months = calendar.monthSymbols

        self.yearRange = yearRange
    }

    var body: some View {
        HStack {
            Picker("", selection: monthBinding) {
                ForEach(0..<months.count, id: \.self) { index in
                    Text(months[index]).tag(index)
                }
            }
            .pickerStyle(platformSpecificPickerStyle)
            .frame(maxWidth: .infinity)

            Picker("", selection: yearBinding) {
                ForEach(yearRange, id: \.self) { year in
                    Text(year.formatted(.number.grouping(.never)))
                        .tag(year)
                }
            }
            .pickerStyle(platformSpecificPickerStyle)
            .frame(maxWidth: .infinity)
        }
        .padding()
    }
    
    /// Returns the appropriate picker style based on the platform.
    private var platformSpecificPickerStyle: some PickerStyle {
        #if os(iOS) || os(tvOS) || os(watchOS)
        return WheelPickerStyle()
        #else
        return DefaultPickerStyle()
        #endif
    }

    private var monthBinding: Binding<Int> {
        Binding(
            get: {
                let components = calendar.dateComponents([.month], from: currentDate)
                return (components.month ?? 1) - 1 // Convert to 0-based index
            },
            set: { newMonth in
                updateDate(month: newMonth + 1) // Convert back to 1-based index
            }
        )
    }

    private var yearBinding: Binding<Int> {
        Binding(
            get: {
                let components = calendar.dateComponents([.year], from: currentDate)
                return components.year ?? calendar.component(.year, from: Date())
            },
            set: { newYear in
                updateDate(year: newYear)
            }
        )
    }

    private func updateDate(month: Int? = nil, year: Int? = nil) {
        var components = calendar.dateComponents([.year, .month, .day], from: currentDate)
        if let newMonth = month {
            components.month = newMonth
        }
        if let newYear = year {
            components.year = newYear
        }

        if let newDate = calendar.date(from: components) {
            currentDate = newDate
        }
    }
}

// MARK: - Preview
private struct MonthYearPicker_Preview: View {
    @State private var currentDate: Date = Date()
    
    var body: some View {
        VStack {
            MonthYearPicker(currentDate: $currentDate)
            Text(currentDate.formatted(.dateTime.day().month().year()))
        }
    }
}

#Preview {
    MonthYearPicker_Preview()
}
