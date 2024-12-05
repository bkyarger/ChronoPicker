//
//  DateRange.swift
//  ChronoPicker
//
//  Created by Gerald Mahlknecht on 05.12.24.
//
import Foundation

public struct DateRange {
    var startDate: Date?
    var endDate: Date?
    
    public init(startDate: Date? = nil, endDate: Date? = nil) {
        self.startDate = startDate
        self.endDate = endDate
    }
}
