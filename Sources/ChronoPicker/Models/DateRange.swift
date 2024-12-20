//
//  DateRange.swift
//  ChronoPicker
//
//  Created by Gerald Mahlknecht on 05.12.24.
//
import Foundation
import SwiftUI

public struct DateRange: Equatable {
    var startDate: Date?
    var endDate: Date?
    
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
