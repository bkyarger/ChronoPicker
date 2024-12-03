//
//  AdvancedExample.swift
//  ChronoPickerExample
//
//  Created by Gerald Mahlknecht on 02.12.24.
//

import SwiftUI
import ChronoPicker

struct AdvancedExample: View {
        
    var body: some View {
        ScrollView {
            VStack(spacing: 40) {
                VStack(alignment: .leading) {
                    Text("Localization")
                        .font(.title2)
                    Text("ChronoPicker supports localization out of the box. Select a locale from the picker to see the date format change.")
                        .font(.footnote)
                        .foregroundStyle(.gray)
                    
                    LocalizationExample()
                }
                
                Divider()
                
                VStack(alignment: .leading) {
                    Text("First day of the week")
                        .font(.title2)
                    Text("The first day of the week can be customized by setting the `firstDayOfTheWeek` property of the `Calendar`.")
                        .font(.footnote)
                        .foregroundStyle(.gray)
                    
                    FirstDayOfTheWeekExample()
                }
                
                Divider()
                
                VStack(alignment: .leading) {
                    Text("Advanced usage example")
                        .font(.title2)
                    Text("ChronoPicker provides a number of advanced features, such as a global disabled property, custom calendar formatting, and more.")
                        .font(.footnote)
                        .foregroundStyle(.gray)
                    
                    AdvancedUsageExample()
                }
            }
            .padding()
        }
    }
}

private struct LocalizationExample: View {
    
    enum ExampleLocale: String, CaseIterable, Identifiable {
        case en_US, de_DE, it_IT
        
        var id: Self { self }
    }
    
    @State private var selectedDate: Date? = nil
    @State private var selectedLocale: ExampleLocale = .en_US
    
    var calendar: Calendar {
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: selectedLocale.rawValue)
        return calendar
    }

    var body: some View {
        VStack {
            Picker("Locale", selection: $selectedLocale) {
                ForEach(ExampleLocale.allCases) { locale in
                    Text(locale.rawValue)
                }
            }
            .pickerStyle(.segmented)
            ChronoDatePicker($selectedDate, calendar: calendar)
        }
    }
}

private struct FirstDayOfTheWeekExample: View {
    
    enum Weekday: String, CaseIterable, Identifiable {
        case mon, tue, wed, thu, fri, sat, sun
        
        var id: Int {
            switch self {
            case .mon:
                2
            case .tue:
                3
            case .wed:
                4
            case .thu:
                5
            case .fri:
                6
            case .sat:
                7
            case .sun:
                1
            }
        }
    }
    
    @State private var selectedDate: Date? = nil
    @State private var selectedWeekday: Weekday = .mon
    
    var calendar: Calendar {
        var calendar = Calendar.current
        calendar.firstWeekday = selectedWeekday.id
        return calendar
    }
    
    var body: some View {
        VStack {
            Picker("First Weekday", selection: $selectedWeekday) {
                ForEach(Weekday.allCases) { locale in
                    Text(locale.rawValue)
                        .tag(locale)
                }
            }
            .pickerStyle(.segmented)
            ChronoDatePicker($selectedDate, calendar: calendar)
        }
    }
}

private struct AdvancedUsageExample: View {

    @State private var showAdjacentMonthDays: Bool = true
    @State private var calendarDisabled: Bool = false
    
    @State private var selectedDate: Date? = nil

    var body: some View {
        VStack {
            Toggle("Show Adjacent Month Days", isOn: $showAdjacentMonthDays)
            Toggle("Calender Disabled", isOn: $calendarDisabled)
            ChronoDatePicker(
                $selectedDate,
                calendar: Calendar.current,
                in: Date()...,
                showAdjacentMonthDays: showAdjacentMonthDays
            )
            .disabled(calendarDisabled)
        }
    }
}

#Preview {
    AdvancedExample()
}
