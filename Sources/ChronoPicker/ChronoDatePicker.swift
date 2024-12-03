//
//  ChronoDatePicker.swift
//  ChronoPicker
//
//  Created by Gerald Mahlknecht on 30.11.24.
//

import SwiftUI

// MARK: - ChronoDatePicker
public struct ChronoDatePicker: View {
    
    @Environment(\.isEnabled) var isEnabled
    
    /// First date of the month
    @State private var currentMonth: Date
    @State private var yearMonthSelectionOpen: Bool = false
    
    @Binding var selectedDate: Date?
    private let calendar: Calendar
    private let dateDisabled: ((Date) -> Bool)?
    private let showAdjacentMonthDays: Bool
    
    public init(
        _ selectedDate: Binding<Date?>,
        calendar: Calendar = Calendar.current,
        dateDisabled: ((Date) -> Bool)? = nil,
        showAdjacentMonthDays: Bool = false
    ) {
        self._selectedDate = selectedDate
        self.calendar = calendar
        self.dateDisabled = dateDisabled
        self.showAdjacentMonthDays = showAdjacentMonthDays
        
        let startOfMonth = calendar.startOfMonth(for: selectedDate.wrappedValue ?? Date())
        self._currentMonth = State(initialValue: startOfMonth)
    }
    
    public var body: some View {
        VStack {
            // MARK: Header
            HStack {
                HStack {
                    Text(monthYearString(for: currentMonth))
                    
                    Image(systemName: "chevron.right")
                        .rotationEffect(.degrees(yearMonthSelectionOpen ? 90 : 0))
                }
                .font(.headline)
                .onTapGesture {
                    withAnimation(.bouncy) {
                        yearMonthSelectionOpen.toggle()
                    }
                }
                
                
                Spacer()
                
                if !yearMonthSelectionOpen {
                    // MARK: Navigaion
                    Group {
                        Button(action: {
                            back()
                        }) {
                            Image(systemName: "chevron.left")
                        }
                        
                        Button(action: {
                            next()
                        }) {
                            Image(systemName: "chevron.right")
                        }
                    }
                    .font(.title2)
                }
            }
            .padding()
            
            // MARK: Content
            ZStack {
                // MARK: Quickselection
                if yearMonthSelectionOpen {
                    let yearMonthSelection = Binding<Date>(
                        get: { currentMonth },
                        set: { self.currentMonth = calendar.startOfMonth(for: $0) }
                    )
                    
                    MonthYearPicker(currentDate: yearMonthSelection)
                        .frame(maxWidth: .infinity)
                } else {
                    VStack {
                        // MARK: Week days
                        WeekdayHeader(calendar: calendar)
                        
                        // MARK: Calendar
                        MonthView(
                            $selectedDate,
                            month: currentMonth,
                            calendar: calendar,
                            dateDisabled: dateDisabled,
                            showAdjacentMonthDays: showAdjacentMonthDays
                        ) { date, selected, adjacent in
                            ChronoPickerDateView_Default(
                                date: date,
                                calendar: calendar,
                                selected: selected,
                                adjacent: adjacent
                            ) {
                                if selected {
                                    selectedDate = nil
                                } else {
                                    selectedDate = date
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    // MARK: Helpers
    
    private func next() {
        currentMonth = calendar.date(byAdding: .month, value: 1, to: currentMonth)!
    }
    private func back() {
        currentMonth = calendar.date(byAdding: .month, value: -1, to: currentMonth)!
    }
    
    private func monthYearString(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        formatter.locale = calendar.locale // Ensure it matches the calendar locale
        return formatter.string(from: date)
    }
}

// MARK: - Initializers
extension ChronoDatePicker {
    public init(
        _ selectedDate: Binding<Date?>,
        calendar: Calendar = Calendar.current,
        in range: Range<Date>,
        showAdjacentMonthDays: Bool = false
    ) {
        self.init(selectedDate, calendar: calendar, dateDisabled: { date in !range.contains(date) }, showAdjacentMonthDays: showAdjacentMonthDays)
    }
    
    public init(
        _ selectedDate: Binding<Date?>,
        calendar: Calendar = Calendar.current,
        in range: PartialRangeFrom<Date>,
        showAdjacentMonthDays: Bool = false
    ) {
        self.init(selectedDate, calendar: calendar, dateDisabled: { date in !range.contains(date) }, showAdjacentMonthDays: showAdjacentMonthDays)
    }
    
    public init(
        _ selectedDate: Binding<Date?>,
        calendar: Calendar = Calendar.current,
        in range: PartialRangeUpTo<Date>,
        showAdjacentMonthDays: Bool = false
    ) {
        self.init(selectedDate, calendar: calendar, dateDisabled: { date in !range.contains(date) }, showAdjacentMonthDays: showAdjacentMonthDays)
    }
    
    public init(
        _ selectedDate: Binding<Date?>,
        calendar: Calendar = Calendar.current,
        in range: ClosedRange<Date>,
        showAdjacentMonthDays: Bool = false
    ) {
        self.init(selectedDate, calendar: calendar, dateDisabled: { date in !range.contains(date) }, showAdjacentMonthDays: showAdjacentMonthDays)
    }
}
