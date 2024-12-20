import XCTest
import SwiftUI
@testable import ChronoPicker

final class ChronoPickerTests: XCTestCase {
    
    let calendar = Calendar.current
    
    let iso8601Calendar = Calendar(identifier: .iso8601)
    
    // MARK: - Dates in month
    func testDatesInMonth() throws {
        let dateComponents = DateComponents(year: 2024, month: 11, day: 15)
        
        guard let testDate = calendar.date(from: dateComponents) else {
            XCTFail("Failed to create test date")
            return
        }
        
        let datesInMonth = calendar.datesInMonth(for: testDate)
        
        XCTAssertEqual(datesInMonth.count, 30, "November 2024 should have 30 days")
        
        XCTAssertEqual(calendar.component(.day, from: datesInMonth.first!), 1, "The first day should be the 1st")
        
        XCTAssertEqual(calendar.component(.day, from: datesInMonth.last!), 30, "The last day should be the 30th")
        
        for (index, date) in datesInMonth.enumerated() where index > 0 {
            let previousDate = datesInMonth[index - 1]
            let expectedNextDate = calendar.date(byAdding: .day, value: 1, to: previousDate)
            XCTAssertEqual(date, expectedNextDate, "Dates should be continuous")
        }
    }
    
    func testDatesInMonthForFebruaryLeapYear() throws {
        let calendar = Calendar.current
        
        let dateComponents = DateComponents(year: 2024, month: 2, day: 15) // leap year
        guard let testDate = calendar.date(from: dateComponents) else {
            XCTFail("Failed to create test date")
            return
        }
        
        let datesInMonth = calendar.datesInMonth(for: testDate)
        
        XCTAssertEqual(datesInMonth.count, 29, "February 2024 should have 29 days")
    }
    
    func testDatesInMonthForInvalidDate() throws {
        let calendar = Calendar.current
        
        let invalidDate = Date.distantFuture // Ensure this is an edge case
        
        let datesInMonth = calendar.datesInMonth(for: invalidDate)
        
        XCTAssertFalse(datesInMonth.isEmpty, "Dates in month should handle distantFuture gracefully")
    }
    
    // MARK: - Weekdays sorted
    func testWeekDaysSortedForSundayStart() {
        var calendar = Calendar.current
        calendar.firstWeekday = 1 // Sunday
        let expected = calendar.shortWeekdaySymbols

        let sortedWeekdays = calendar.weekDaysSorted

        XCTAssertEqual(sortedWeekdays, expected, "Weekdays should start with Sunday when firstWeekday is 1.")
    }

    func testWeekDaysSortedForMondayStart() {
        var calendar = Calendar.current
        calendar.firstWeekday = 2 // Monday
        let expected = Array(calendar.shortWeekdaySymbols[1...]) + [calendar.shortWeekdaySymbols[0]]

        let sortedWeekdays = calendar.weekDaysSorted

        XCTAssertEqual(sortedWeekdays, expected, "Weekdays should start with Monday when firstWeekday is 2.")
    }

    func testWeekDaysSortedForSaturdayStart() {
        var calendar = Calendar.current
        calendar.firstWeekday = 7 // Saturday
        let expected = [calendar.shortWeekdaySymbols[6]] + Array(calendar.shortWeekdaySymbols[0..<6])

        let sortedWeekdays = calendar.weekDaysSorted

        XCTAssertEqual(sortedWeekdays, expected, "Weekdays should start with Saturday when firstWeekday is 7.")
    }

    func testWeekDaysSortedContainsAllSymbols() {
        let calendar = Calendar.current
        let expectedSymbols = Set(calendar.shortWeekdaySymbols)

        let sortedWeekdays = calendar.weekDaysSorted
        let sortedSymbolsSet = Set(sortedWeekdays)

        XCTAssertEqual(sortedSymbolsSet, expectedSymbols, "Sorted weekdays should contain all original weekday symbols.")
    }

    func testWeekDaysSortedForISO8601Calendar() {
        var calendar = Calendar(identifier: .iso8601)
        calendar.firstWeekday = 2 // ISO8601 defaults to Monday start
        let expected = Array(calendar.shortWeekdaySymbols[1...]) + [calendar.shortWeekdaySymbols[0]]

        let sortedWeekdays = calendar.weekDaysSorted

        XCTAssertEqual(sortedWeekdays, expected, "ISO8601 calendar should sort weekdays starting with Monday.")
    }
    
    // MARK: - Date grid

    func testCalendarDatesWithAdjacentDays() {
        
        let testDate = iso8601Calendar.date(from: DateComponents(year: 2024, month: 11, day: 1))! // November 2024 with start on monday has 4 leading adjacent days and 1 trailing
        let includeAdjacent = true
        
        let dates = iso8601Calendar.calendarDates(in: testDate, includeAdjacent: includeAdjacent)
                
        let leadingDates = dates.prefix(4).compactMap { $0 }
        XCTAssertTrue(leadingDates.allSatisfy { iso8601Calendar.component(.month, from: $0) == 10 }, "Leading adjacent dates should belong to October.")
        
        let trailingDates = dates.suffix(1).compactMap { $0 }
        XCTAssertTrue(trailingDates.allSatisfy { iso8601Calendar.component(.month, from: $0) == 12 }, "Trailing adjacent dates should belong to December.")
    }
    
    func testLeadingAdjacentDates() {
        let testDate = iso8601Calendar.date(from: DateComponents(year: 2024, month: 11, day: 1))! // November 2024 with start on monday has 4 leading adjacent days and 1 trailing
        
        let leadingDates = iso8601Calendar.leadingAdjacentDates(for: testDate)
        
        XCTAssertEqual(leadingDates.count, 4, "November 2024 starts on a Wednesday, so it should have 3 leading adjacent days.")
        XCTAssertEqual(leadingDates.first, iso8601Calendar.date(from: DateComponents(year: 2024, month: 10, day: 28)), "The first leading adjacent date should be October 28 (Monday), 2024.")
    }
    
    func testTrailingAdjacentDates() {
        let testDate = iso8601Calendar.date(from: DateComponents(year: 2024, month: 11, day: 1))!
        
        let trailingDates = iso8601Calendar.trailingAdjacentDates(for: testDate)
        
        XCTAssertEqual(trailingDates.count, 1, "November 2024 ends on a Saturday, so it should have 2 trailing adjacent days.")
        XCTAssertEqual(trailingDates.first, iso8601Calendar.date(from: DateComponents(year: 2024, month: 12, day: 1)), "The first trailing adjacent date should be December 1, 2024.")
    }
    
    func testDateGrid() {
        let testDate = iso8601Calendar.date(from: DateComponents(year: 2024, month: 11, day: 1))!
        
        let datesInMonth = iso8601Calendar.datesInMonth(for: testDate)
        
        XCTAssertEqual(datesInMonth.count, 30, "November 2024 has 30 days.")
        XCTAssertEqual(datesInMonth.first, calendar.date(from: DateComponents(year: 2024, month: 11, day: 1)), "The first date should be November 1, 2024.")
        XCTAssertEqual(datesInMonth.last, calendar.date(from: DateComponents(year: 2024, month: 11, day: 30)), "The last date should be November 30, 2024.")
    }
}
