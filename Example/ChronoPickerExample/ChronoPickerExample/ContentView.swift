//
//  ContentView.swift
//  ChronoPickerExample
//
//  Created by Gerald Mahlknecht on 02.12.24.
//

import SwiftUI
import ChronoPicker

struct ContentView: View {
    
    @State private var selectedDate: Date? = nil
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Date Picker")) {
                    NavigationLink {
                        BasicExample()
                    } label: {
                        Text("Basic Usage")
                    }
                    NavigationLink {
                        DisabledDatesExample()
                    } label: {
                        Text("Disabled Dates")
                    }
                    NavigationLink {
                        AdvancedExample()
                    } label: {
                        Text("Advanced Examples")
                    }
                }
                Section(header: Text("Date Range Picker")) {
                    NavigationLink {
                        RangePickerExample()
                    } label: {
                        Text("Range Picker")
                    }
                }
            }
            .navigationTitle("ChronoPicker Examples")
        }
    }
}

#Preview {
    ContentView()
}
