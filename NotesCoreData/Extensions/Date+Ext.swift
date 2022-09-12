//
//  Date+Ext.swift
//  NotesCoreData
//
//  Created by Kiran on 12/09/22.
//

import Foundation
extension Date {
    static func isToday(day: Int) -> Bool {
        return Calendar.current.dateComponents([.day], from: .now).day == day
    }
    
    static func isThisYear(year: Int) -> Bool {
        return Calendar.current.dateComponents([.year], from: .now).year == year
    }
    
    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}

