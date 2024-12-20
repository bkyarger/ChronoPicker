//
//  DateGrid.swift
//  ChronoPicker
//
//  Created by Gerald Mahlknecht on 30.11.24.
//

import SwiftUI

struct DateGrid<DateView: View>: View {
    
    private var month: Date
    private let calendar: Calendar
    private let dateDisabled: ((Date) -> Bool)?
    private let showAdjacentMonthDays: Bool
    
    private var selectedDates: [Date]
    
    private let selectDate: (_ date: Date) -> Void

    private let dateView: (_ date: Date, _ adjacent: Bool) -> DateView
    
    init(
        month: Date,
        calendar: Calendar = Calendar.current,
        dateDisabled: ((Date) -> Bool)? = nil,
        showAdjacentMonthDays: Bool = false,
        selectedDates: [Date],
        selectDate: @escaping (_ date: Date) -> Void,
        @ViewBuilder dateView: @escaping (_ date: Date, _ adjacent: Bool) -> DateView
    ) {
        self.month = month
        self.calendar = calendar
        self.dateDisabled = dateDisabled
        self.showAdjacentMonthDays = showAdjacentMonthDays
        self.selectDate = selectDate
        self.dateView = dateView
        self.selectedDates = selectedDates
    }

    var body: some View {
        let datesForMonth = calendar.calendarDates(in: month, includeAdjacent: showAdjacentMonthDays)
            
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
            
            if !showAdjacentMonthDays {
                let preOffset = calendar.leadingAdjacentDates(for: month)
                
                ForEach(Array(preOffset), id: \.self) { _ in
                    Text("")
                        .frame(maxWidth: .infinity)
                }
            }
            
            ForEach(datesForMonth, id: \.self) { date in
                let adjacent = calendar.component(.month, from: date) != calendar.component(.month, from: month)
                let disabled = isDateDisabled(date: date)
                
                dateView(
                    date,
                    adjacent
                )
                .disabled(disabled)
                .onTapGesture {
                    selectDate(date)
                }

            }
            
            if !showAdjacentMonthDays {
                let postOffset = calendar.trailingAdjacentDates(for: month)
                
                ForEach(Array(postOffset), id: \.self) { _ in
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
}
