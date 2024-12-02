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
    var adjacent: Bool { get }
    var onClick: () -> Void { get }
}

struct ChronoPickerDateView_Default: ChronoPickerDateView {
    @Environment(\.isEnabled) var isEnabled
    
    let date: Date
    let calendar: Calendar
    let selected: Bool
    var adjacent: Bool = false
    let onClick: () -> Void
    
    var isToday: Bool {
        calendar.isDateInToday(date)
    }
    
    var fontWeight: Font.Weight {
        if !isEnabled {
            return .light
        }
        if selected {
            return .semibold
        }
        return .medium
    }
    
    var foregroundStyle: some ShapeStyle {
        if !isEnabled {
            return Color.gray
        }
        if adjacent {
            return Color.gray
        }
        
        return Color.primary
    }
    
    var body: some View {
        Text("\(calendar.component(.day, from: date))")
            .fontWeight(fontWeight)
            .frame(maxWidth: .infinity)
            .frame(height: 40)
            .frame(width: 40)
            .background(selected ? Color.accentColor : Color.clear)
            .foregroundStyle(foregroundStyle)
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

// TODO: Create preview matrix
#Preview {
    let today = Date()
    let calendar = Calendar.current
    let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
    
    VStack {
        ChronoPickerDateView_Default(date: yesterday, calendar: calendar, selected: false, onClick: {
            print("selected date")
        })
        ChronoPickerDateView_Default(date: yesterday, calendar: calendar, selected: true, onClick: {
            print("selected date")
        })
        ChronoPickerDateView_Default(date: yesterday, calendar: calendar, selected: false, onClick: {
            print("selected date")
        })
        .disabled(true)
        ChronoPickerDateView_Default(date: today, calendar: calendar, selected: false, adjacent: true, onClick: {
            print("selected date")
        })
        ChronoPickerDateView_Default(date: yesterday, calendar: calendar, selected: false, adjacent: true, onClick: {
            print("selected date")
        })
    }
    .frame(maxWidth: 40)
}
