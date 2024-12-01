//
//  ChronoCalendar.swift
//  ChronoPicker
//
//  Created by Gerald Mahlknecht on 30.11.24.
//

import SwiftUI

struct ChronoCalendar: View {
    
    @Binding var selectedDate: Date?
    let month: Date
    var calendar: Calendar = Calendar.current
    let dateDisabled: ((Date) -> Bool)?

    var body: some View {
        let daysInMonth = calendar.datesInMonth(for: month)
        
        let firstWeekday = calendar.component(.weekday, from: month)
        let padding = (firstWeekday - calendar.firstWeekday + 7) % 7
        
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
            ForEach(0..<padding, id: \.self) { _ in
                Text("")
                    .frame(maxWidth: .infinity)
            }
            
            ForEach(daysInMonth, id: \.self) { date in
                let selected = isDateSelected(date: date)
                let disabled = isDateDisabled(date: date)
                
                // MARK: Date render
                ChronoPickerDateView_Default(date: date, calendar: calendar, selected: selected) {
                    if selected {
                        selectedDate = nil
                    } else {
                        selectedDate = date
                    }
                }
                .disabled(disabled)
            }
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
