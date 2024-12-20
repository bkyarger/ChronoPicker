//
//  DateRange.swift
//  ChronoPicker
//
//  Created by Gerald Mahlknecht on 05.12.24.
//
import Foundation
import SwiftUI

public struct DateRange: Equatable {
    
    private var _startDate: Date? = nil
    private var _endDate: Date? = nil

    
    var calendar = Calendar.current
    
    var startDate: Date? {
        get {
            _startDate
        }
        set {
            if let newValue {
                self._startDate = calendar.startOfDay(for: newValue)
            }
        }
    }
    
    var endDate: Date? {
        get {
            _endDate
        }
        set {
            if let newValue {
                self._endDate = calendar.startOfDay(for: newValue)
            }
        }
    }
    
    public init(startDate: Date? = nil, endDate: Date? = nil) {
        self.startDate = startDate
        self.endDate = endDate
    }
    
    public var description: String {
        if let startDate, let endDate {
            return "\(startDate.formatted(.dateTime.day().month().year())) - \(endDate.formatted(.dateTime.day().month().year()))"
        }
        if let startDate {
            return "\(startDate.formatted(.dateTime.day().month().year())) - Open End"
        }
        
        if let endDate {
            // Should never be executed
            return "Open Start - \(endDate.formatted(.dateTime.day().month().year()))"
        }
        
        return "Nothing selected"
    }
}
