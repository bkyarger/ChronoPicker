//
//  ChronoDateView.swift
//  ChronoPicker
//
//  Created by Gerald Mahlknecht on 30.11.24.
//

import SwiftUI

struct ChronoDateView: View {
    @Environment(\.isEnabled) var isEnabled
    
    let date: Date
    let calendar: Calendar
    let selected: Bool
    var adjacent: Bool = false
    
    var isToday: Bool {
        calendar.isDateInToday(date)
    }
    
    var fontWeight: Font.Weight {
        if !isEnabled {
            return .light
        }
        if selected || isToday {
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
        if selected {
            return Color.black
        }
        if isToday {
            return Color.accentColor
        }
        
        return Color.primary
    }
    
    var body: some View {
        Text("\(calendar.component(.day, from: date))")
            .fontWeight(fontWeight)
            .frame(maxWidth: .infinity)
            .frame(height: 40)
            .frame(width: 40)
            .background(selected ? Color.accentColor.opacity(0.5) : Color.clear)
            .foregroundStyle(foregroundStyle)
            .cornerRadius(20)
            .modify { view in
                if #available(iOS 16.0, *) {
                    view.strikethrough(!isEnabled)
                } else {
                    view
                }
            }
    }
}
