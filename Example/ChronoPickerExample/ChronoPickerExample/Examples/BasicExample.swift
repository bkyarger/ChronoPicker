//
//  BasicExample.swift
//  ChronoPickerExample
//
//  Created by Gerald Mahlknecht on 02.12.24.
//

import SwiftUI
import ChronoPicker

struct BasicExample: View {
    
    @State private var selectedDate: Date? = Date()

    var body: some View {
        VStack {
            ChronoDatePicker($selectedDate)
                .padding()
            Spacer()
            Group {
                if let selectedDate {
                    Text("Selected date \(selectedDate.formatted(.dateTime.day().month().year()))")
                } else {
                    Text("No date selected")
                }
            }
            .font(.title2)
        }
        .navigationTitle("Basic Example")
    }
}

#Preview {
    NavigationStack {
        BasicExample()
    }
}
