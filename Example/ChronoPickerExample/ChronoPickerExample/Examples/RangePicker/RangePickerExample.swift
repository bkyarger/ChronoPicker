//
//  RangePickerExample.swift
//  ChronoPicker
//
//  Created by Gerald Mahlknecht on 03.12.24.
//
import SwiftUI
import ChronoPicker

struct RangePickerExample: View {
    
    @State private var selectedDateRange: DateRange = DateRange(startDate: Date(), endDate: Calendar.current.date(byAdding: .day, value: 10, to: Date()))
    
    var body: some View {
        ChronoDatePicker($selectedDateRange)
    }
}

#Preview {
    RangePickerExample()
}
