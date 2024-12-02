//
//  DisabledDatesExample.swift
//  ChronoPickerExample
//
//  Created by Gerald Mahlknecht on 02.12.24.
//

import SwiftUI
import ChronoPicker

struct DisabledDatesExample: View {
    
    @State private var selectedDate: Date? = nil
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                VStack(alignment: .leading) {
                    Text("Range")
                        .font(.title2)
                    Text("Only dates within the specified range are selectable. The example shows how to disable future dates.")
                        .font(.footnote)
                        .foregroundStyle(.gray)
                    
                    ChronoDatePicker($selectedDate, in: ..<Date())
                }
                Divider()
                VStack(alignment: .leading) {
                    Text("Callback")
                        .font(.title2)
                    Text("By specifying a callback, one can disable specific dates. This examples shows hows to disable weekends.")
                        .font(.footnote)
                        .foregroundStyle(.gray)
                    
                    ChronoDatePicker($selectedDate, dateDisabled: { Calendar.current.isDateInWeekend($0) })
                    
                }
            }
            .padding()
        }
        .navigationTitle("Disabled Dates")
    }
}

#Preview {
    NavigationStack {
        DisabledDatesExample()
    }
}
