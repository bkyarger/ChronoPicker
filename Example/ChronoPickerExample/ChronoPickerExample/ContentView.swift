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
        ChronoDatePicker($selectedDate)
    }
}

#Preview {
    ContentView()
}
