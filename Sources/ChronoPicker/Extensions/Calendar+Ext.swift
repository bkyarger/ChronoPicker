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
    
    func startOfMonth(for date: Date) -> Date {
        self.date(from: self.dateComponents([.year, .month], from: date))!
    }
    
    func datesAreEqual(date1: Date, date2: Date) -> Bool {
        return self.isDate(date1, equalTo: date2, toGranularity: .day)
    }
    
    func calendarDates(in month: Date, includeAdjacent: Bool) -> [Date?] {
        let datesInMonth = datesInMonth(for: month)
        
        let leadingAdjacentDates = self.leadingAdjacentDates(for: month)
        let trailingAdjacentDates = self.trailingAdjacentDates(for: month)
        
        if !includeAdjacent {
            return Array(repeating: nil, count: leadingAdjacentDates.count) + datesInMonth + Array(repeating: nil, count: trailingAdjacentDates.count)
        }
        
        return leadingAdjacentDates + datesInMonth + trailingAdjacentDates
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
    
    func leadingAdjacentDates(for month: Date) -> [Date] {
        let daysInPreviousMonth = self.datesInMonth(for: self.date(byAdding: .month, value: -1, to: month)!)

        let firstWeekday = self.component(.weekday, from: month)
        let prePadding = (firstWeekday - self.firstWeekday + 7) % 7
        
        let adjacentMonthDays = Array(daysInPreviousMonth.suffix(prePadding))
        
        return adjacentMonthDays
    }
    
    func trailingAdjacentDates(for month: Date) -> [Date] {
        guard let range = self.range(of: .day, in: .month, for: month) else { return [] }
        let numberOfDaysInMonth = range.count
        
        let firstWeekday = self.firstWeekday
        
        guard let firstDayOfMonth = self.date(from: self.dateComponents([.year, .month], from: month)) else {
            return [] }
        let lastDayOfMonth = self.date(byAdding: .day, value: numberOfDaysInMonth - 1, to: firstDayOfMonth)!
        
        let lastDayWeekday = (self.component(.weekday, from: lastDayOfMonth) - firstWeekday + 7) % 7
        
        let trailingDays = (6 - lastDayWeekday) % 7
        
        guard let firstDayOfNextMonth = self.date(byAdding: .month, value: 1, to: firstDayOfMonth) else {
            return [] }
                
        return (0..<trailingDays).compactMap {
            self.date(byAdding: .day, value: $0, to: firstDayOfNextMonth)
        }
    }
}
