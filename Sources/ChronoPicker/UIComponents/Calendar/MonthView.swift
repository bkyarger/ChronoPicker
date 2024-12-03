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
        let dates = calendar.calendarDates(in: month, includeAdjacent: showAdjacentMonthDays)
        
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
            
            ForEach(dates, id: \.self) { optionalDate in
                if let date = optionalDate {
                    let selected = isDateSelected(date: date)
                    let disabled = isDateDisabled(date: date)
                    
                    dateView(
                        date,
                        selected,
                        false
                    )
                    .disabled(disabled)
                } else {
                    Text("")
                        .frame(maxWidth: .infinity)
                }
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
