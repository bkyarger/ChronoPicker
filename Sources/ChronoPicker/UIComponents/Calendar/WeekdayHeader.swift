//
//  WeekdayHeader.swift
//  ChronoPicker
//
//  Created by Gerald Mahlknecht on 30.11.24.
//

import SwiftUI

struct WeekdayHeader: View {
    
    var calendar: Calendar = Calendar.current
    
    var weekdaySymbols: [String] {
        calendar.weekDaysSorted
    }
    
    var body: some View {
        HStack {
            ForEach(weekdaySymbols, id: \.self) { weekdaySymbol in
                Text(weekdaySymbol)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
                    .font(.headline)
            }
        }
    }
}
