//
//  Demo1.swift
//  ChronoPickerExample
//
//  Created by Gerald Mahlknecht on 03.12.24.
//

import SwiftUI
import ChronoPicker

struct Demo1: View {
    var body: some View {
        VStack {
            ChronoDatePicker(Binding.constant(Date()))
            Spacer()
        }
    }
}

#Preview {
    Demo1()
}
