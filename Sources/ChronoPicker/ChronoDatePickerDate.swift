//
//  SwiftUIView.swift
//  ChronoPicker
//
//  Created by Gerald Mahlknecht on 30.11.24.
//

import SwiftUI

public protocol ChronoPickerDateView: View {
    var date: Date { get }
    var calendar: Calendar { get }
    var selected: Bool { get }
    var onClick: () -> Void { get }
}

struct ChronoPickerDateView_Default: ChronoPickerDateView {
    
    @Environment(\.isEnabled) var isEnabled
    
    let date: Date
    let calendar: Calendar
    let selected: Bool
    let onClick: () -> Void
    
    var fontWeight: Font.Weight {
        if !isEnabled {
            return .light
        }
        if selected {
            return .semibold
        }
        return .medium
    }
    
    var body: some View {
        Text("\(calendar.component(.day, from: date))")
            .fontWeight(fontWeight)
            .frame(maxWidth: .infinity)
            .frame(height: 40)
            .frame(width: 40)
            .background(selected ? Color.accentColor : Color.clear)
            .foregroundStyle(!isEnabled ? Color.gray : Color.primary)
            .cornerRadius(20)
            .onTapGesture(perform: onClick)
            .modify { view in
                if #available(iOS 16.0, *) {
                    view.strikethrough(!isEnabled)
                } else {
                    view
                }
            }
    }
}

#Preview {
    VStack {
        ChronoPickerDateView_Default(date: Date(), calendar: Calendar.current, selected: false, onClick: {
            print("selected date")
        })
        ChronoPickerDateView_Default(date: Date(), calendar: Calendar.current, selected: true, onClick: {
            print("selected date")
        })
        ChronoPickerDateView_Default(date: Date(), calendar: Calendar.current, selected: false, onClick: {
            print("selected date")
        })
        .disabled(true)
    }
    .frame(maxWidth: 40)
}
