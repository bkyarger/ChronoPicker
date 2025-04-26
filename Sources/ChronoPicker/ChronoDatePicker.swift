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
    
    private let mode: ChronoDatePickerMode
    
    /// First date of the month
    @State private var currentMonth: Date
    @State private var yearMonthSelectionOpen: Bool = false
    
    @Binding var selectedDate: Date?
    @Binding var selectedDateRange: DateRange
    
    private let calendar: Calendar
    private let dateDisabled: ((Date) -> Bool)?
    private let showAdjacentMonthDays: Bool
    private let customDateView: ((_ date: Date, _ selected: Bool, _ adjacent: Bool) -> (AnyView))?
    
    var selectedDates: [Date] {
        switch mode {
        case .single:
            guard let selectedDate else { return [] }
            return [selectedDate]
        case .range:
            if let startDate = selectedDateRange.startDate, let endDate = selectedDateRange.endDate {
                // Return both dates if both are set
                return [startDate, endDate]
            } else if let startDate = selectedDateRange.startDate {
                // Return just the start date if the end date is not set
                return [startDate]
            } else if let endDate = selectedDateRange.endDate {
                // Return just the end date (this case might be rare)
                return [endDate]
            }
            // Return an empty array if neither start nor end date is set
            return []
            
        }
    }
    
    init(
        mode: ChronoDatePickerMode,
        selectedDate: Binding<Date?>,
        selectedDateRange: Binding<DateRange>,
        calendar: Calendar = Calendar.current,
        in range: (any RangeExpression<Date>)?,
        dateDisabled: ((_ date: Date) -> Bool)?,
        showAdjacentMonthDays: Bool,
        customDateView: ((_ date: Date, _ selected: Bool, _ adjacent: Bool) -> (AnyView))?
    ) {
        self.mode = mode
        
        self._selectedDate = selectedDate
        self._selectedDateRange = selectedDateRange
        
        self.calendar = calendar
        self.dateDisabled = { date in
            if let range {
                return !range.contains(date)
            }
            if let dateDisabled {
                return dateDisabled(date)
            }
            return false
        }
        self.showAdjacentMonthDays = showAdjacentMonthDays
        
        let startOfMonth = calendar.startOfMonth(for: selectedDate.wrappedValue ?? Date())
        self.customDateView = customDateView
        
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
            
            // MARK: Quickselection
            if yearMonthSelectionOpen {
                let yearMonthSelection = Binding<Date>(
                    get: { currentMonth },
                    set: { self.currentMonth = calendar.startOfMonth(for: $0) }
                )
                
                MonthYearPicker(currentDate: yearMonthSelection)
                    .frame(maxWidth: .infinity)
            } else {
                // MARK: Week days
                WeekdayHeader(calendar: calendar)
                
                // MARK: Calendar
                DateGrid(
                    month: currentMonth,
                    calendar: calendar,
                    dateDisabled: dateDisabled,
                    showAdjacentMonthDays: showAdjacentMonthDays,
                    selectedDates: selectedDates,
                    selectDate: selectDate
                ) { date, adjacent in
                    let selected = isDateSelected(date: date)
                    
                    if let customDateView {
                        AnyView(customDateView(date, selected, adjacent))
                    } else {
                        ChronoDateView(
                            date: date,
                            calendar: calendar,
                            selected: selected,
                            withinRange: false,
                            adjacent: adjacent
                        )
                    }
                }
                .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                    .onEnded({ value in
                        if value.translation.width < 0 {
                            back()
                        }
                        
                        if value.translation.width > 0 {
                            next()
                        }
                    }))
            }
        }
    }
    
    private func selectDate(date: Date) {
        switch mode {
        case .single:
            if let selectedDate, calendar.datesAreEqual(date1: date, date2: selectedDate) {
                // Deselect the date if it's already selected
                self.selectedDate = nil
            } else {
                // Select the new date
                self.selectedDate = date
            }
            
        case .range:
            if selectedDateRange.startDate == nil {
                if let currentStartDate = selectedDateRange.startDate, calendar.isDate(currentStartDate, equalTo: date, toGranularity: .day) {
                    self.selectedDateRange.startDate = nil
                } else {
                    self.selectedDateRange.startDate = date
                }
            } else if let startDate = selectedDateRange.startDate, date > startDate {
                if let currentEndDate = self.selectedDateRange.endDate, calendar.isDate(currentEndDate, equalTo: date, toGranularity: .day) {
                    self.selectedDateRange.endDate = nil
                } else {
                    self.selectedDateRange.endDate = date
                }
            } else {
                // Reset the range if the conditions above aren't met
                if let currentStartDate = selectedDateRange.startDate, calendar.isDate(currentStartDate, equalTo: date, toGranularity: .day) {
                    self.selectedDateRange.startDate = nil
                } else {
                    self.selectedDateRange.startDate = date
                }
                self.selectedDateRange.endDate = nil
            }
        }
    }
    
    private func isDateSelected(date: Date) -> Bool {
        switch mode {
        case .single:
            guard let selectedDate else { return false }
            return calendar.datesAreEqual(date1: date, date2: selectedDate)
        case .range:
            if let startDate = selectedDateRange.startDate, let endDate = selectedDateRange.endDate {
                let dateRange: ClosedRange = startDate...endDate
                return dateRange.contains(date)
            } else if let startDate = selectedDateRange.startDate {
                print("here \(startDate.description)")
                return calendar.datesAreEqual(date1: date, date2: startDate)
            } else if let endDate = selectedDateRange.endDate {
                return calendar.datesAreEqual(date1: date, date2: endDate)
            } else {
                return false
            }
        }
    }
    
    private func monthYearString(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        formatter.locale = calendar.locale // Ensure it matches the calendar locale
        return formatter.string(from: date)
    }
}

// MARK: Navigation
extension ChronoDatePicker {
    private func next() {
        currentMonth = calendar.date(byAdding: .month, value: 1, to: currentMonth)!
    }
    private func back() {
        currentMonth = calendar.date(byAdding: .month, value: -1, to: currentMonth)!
    }
}

// MARK: Initializers
extension ChronoDatePicker {
    public init(
        _ selectedDate: Binding<Date?>,
        calendar: Calendar = Calendar.current,
        in range: (any RangeExpression<Date>)? = nil,
        dateDisabled: ((_ date: Date) -> Bool)? = nil,
        showAdjacentMonthDays: Bool = false,
        customDateView: ((_ date: Date, _ selected: Bool, _ adjacent: Bool) -> (AnyView))? = nil
    ) {
        self.init(
            mode: .single,
            selectedDate: selectedDate,
            selectedDateRange: Binding.constant(DateRange()),
            calendar: calendar,
            in: range,
            dateDisabled: dateDisabled,
            showAdjacentMonthDays: showAdjacentMonthDays,
            customDateView: customDateView
        )
    }
    
    public init(
        _ selectedDateRange: Binding<DateRange>,
        calendar: Calendar = Calendar.current,
        in range: (any RangeExpression<Date>)? = nil,
        dateDisabled: ((_ date: Date) -> Bool)? = nil,
        showAdjacentMonthDays: Bool = false,
        customDateView: ((_ date: Date, _ selected: Bool, _ adjacent: Bool) -> (AnyView))? = nil
    ) {
        self.init(
            mode: .range,
            selectedDate: Binding.constant(nil),
            selectedDateRange: selectedDateRange,
            calendar: calendar,
            in: range,
            dateDisabled: dateDisabled,
            showAdjacentMonthDays: showAdjacentMonthDays,
            customDateView: customDateView
        )
    }
}
