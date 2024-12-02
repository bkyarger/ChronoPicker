//
//  DatePicker.swift
//  ChronoPicker
//
//  Created by Gerald Mahlknecht on 30.11.24.
//

import SwiftUI

struct MonthView<DateView: View>: View {
    
    @Binding private var selectedDate: Date?
    private let month: Date
    private let calendar: Calendar
    private let dateDisabled: ((Date) -> Bool)?
    
    private let dateView: (_ date: Date, _ selected: Bool) -> DateView
    
    init(
        _ selectedDate: Binding<Date?>,
        month: Date,
        calendar: Calendar = Calendar.current,
        dateDisabled: ((Date) -> Bool)? = nil,
        @ViewBuilder dateView: @escaping (_ date: Date, _ selected: Bool) -> DateView
    ) {
        _selectedDate = selectedDate
        self.month = month
        self.calendar = calendar
        self.dateDisabled = dateDisabled
        self.dateView = dateView
    }

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
                dateView(
                    date,
                    selected
                )
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
