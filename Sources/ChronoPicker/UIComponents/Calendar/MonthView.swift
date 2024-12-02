//
//  DatePicker.swift
//  ChronoPicker
//
//  Created by Gerald Mahlknecht on 30.11.24.
//

import SwiftUI

struct MonthView<DateView: View>: View {
    
    @Binding private var selectedDate: Date?
    private var month: Date
    private let calendar: Calendar
    private let dateDisabled: ((Date) -> Bool)?
    private let showAdjacentMonthDays: Bool
    
    private let dateView: (_ date: Date, _ selected: Bool, _ adjacent: Bool) -> DateView
    
    init(
        _ selectedDate: Binding<Date?>,
        month: Date,
        calendar: Calendar = Calendar.current,
        dateDisabled: ((Date) -> Bool)? = nil,
        showAdjacentMonthDays: Bool = false,
        @ViewBuilder dateView: @escaping (_ date: Date, _ selected: Bool, _ adjacent: Bool) -> DateView
    ) {
        _selectedDate = selectedDate
        self.month = month
        self.calendar = calendar
        self.dateDisabled = dateDisabled
        self.showAdjacentMonthDays = showAdjacentMonthDays
        self.dateView = dateView
    }

    var body: some View {
        let daysInMonth = calendar.datesInMonth(for: month)
        
        let firstWeekday = calendar.component(.weekday, from: month)
        let prePadding = (firstWeekday - calendar.firstWeekday + 7) % 7
        
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
            
            if showAdjacentMonthDays {
                let daysInPreviousMonth = calendar.datesInMonth(for: calendar.date(byAdding: .month, value: -1, to: month)!)
                
                let adjacentMonthDays = Array(daysInPreviousMonth.suffix(prePadding))
                
                ForEach(adjacentMonthDays, id: \.self) { date in
                    let selected = isDateSelected(date: date)

                    dateView(date, selected, true)
                }
            } else {
                ForEach(0..<prePadding, id: \.self) { _ in
                    Text("")
                        .frame(maxWidth: .infinity)
                }
            }
            
            ForEach(daysInMonth, id: \.self) { date in
                let selected = isDateSelected(date: date)
                let disabled = isDateDisabled(date: date)
                
                // MARK: Date render
                dateView(
                    date,
                    selected,
                    false
                )
                .disabled(disabled)
            }
            
            if showAdjacentMonthDays {
                let trailingDates = trailingAdjacentDates(for: month)

                ForEach(trailingDates, id: \.self) { date in
                    let selected = isDateSelected(date: date)

                    dateView(date, selected, true)
                }
            }
        }
    }
    
    private func trailingAdjacentDates(for date: Date) -> [Date] {
        guard let range = calendar.range(of: .day, in: .month, for: date) else { return [] }
        let numberOfDaysInMonth = range.count
        
        let firstWeekday = calendar.firstWeekday
        
        guard let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: date)) else {
            return [] }
        let lastDayOfMonth = calendar.date(byAdding: .day, value: numberOfDaysInMonth - 1, to: firstDayOfMonth)!
        
        let lastDayWeekday = (calendar.component(.weekday, from: lastDayOfMonth) - firstWeekday + 7) % 7
        
        let trailingDays = (6 - lastDayWeekday) % 7
        
        guard let firstDayOfNextMonth = calendar.date(byAdding: .month, value: 1, to: firstDayOfMonth) else {
            return [] }
                
        return (0..<trailingDays).compactMap {
            calendar.date(byAdding: .day, value: $0, to: firstDayOfNextMonth)
        }
    }
    
    private func isDateDisabled(date: Date) -> Bool {
        guard let dateDisabled else {
            return false
        }
        return dateDisabled(date)
    }
    
    private func isDateSelected(date: Date) -> Bool {
        if let selectedDate = selectedDate {
            return calendar.datesAreEqual(date1: date, date2: selectedDate)
        }
        return false
    }
}
