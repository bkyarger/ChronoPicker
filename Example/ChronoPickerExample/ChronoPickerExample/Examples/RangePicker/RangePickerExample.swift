//
//  RangePickerExample.swift
//  ChronoPicker
//
//  Created by Gerald Mahlknecht on 03.12.24.
//
import SwiftUI
import ChronoPicker

struct RangePickerExample: View {
    
    @State private var selectedDateRange: DateRange = DateRange(startDate: Date(), endDate: Calendar.current.date(byAdding: .day, value: 4, to: Date()))
    
    var body: some View {
        VStack {
            ChronoDatePicker($selectedDateRange)
            Text(selectedDateRange.description)
        }
    }
}

#Preview {
    RangePickerExample()
}
