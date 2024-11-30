//
//  Calendar+Ext.swift
//  ChronoPicker
//
//  Created by Gerald Mahlknecht on 30.11.24.
//
import Foundation

extension Calendar {
    
    var weekDaysSorted: [String] {
        let symbols = self.shortWeekdaySymbols
        let firstWeekday = self.firstWeekday
        return Array(symbols[firstWeekday-1..<symbols.count]) + symbols[0..<firstWeekday-1]
    }
    
    func datesInMonth(for date: Date) -> [Date] {
        guard let startOfMonth = self.date(from: self.dateComponents([.year, .month], from: date)) else {
            return []
        }
        let range = self.range(of: .day, in: .month, for: startOfMonth) ?? 1..<30
        return range.compactMap { day in
            self.date(byAdding: .day, value: day - 1, to: startOfMonth)
        }
    }
    
    func startOfMonth(for date: Date) -> Date {
        self.date(from: self.dateComponents([.year, .month], from: date))!
    }
    
    func datesAreEqual(date1: Date, date2: Date) -> Bool {
        return self.isDate(date1, equalTo: date2, toGranularity: .day)
    }
}
