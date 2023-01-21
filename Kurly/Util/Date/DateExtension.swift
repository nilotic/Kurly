//
//  DateExtension.swift
//  Kurly
//
//  Created by Den Jo on 2023/01/21.
//

import Foundation

extension Date {
    
    var year: Int {
        Calendar.current.component(.year, from: self)
    }
    
    var month: Int {
        Calendar.current.component(.month, from: self)
    }
    
    var day: Int {
        Calendar.current.component(.day, from: self)
    }
    
    var hour: Int {
        Calendar.current.component(.hour, from: self)
    }
    
    var minute: Int {
        Calendar.current.component(.minute, from: self)
    }
    
    var weekDay: Int {
        Calendar.current.component(.weekday, from: self)
    }
    
    var weekOfMonth: Int {
        Calendar.current.component(.weekOfMonth, from: self)
    }
    
    var weekdayOrdinal: Int {
        Calendar.current.component(.weekdayOrdinal, from: self)
    }
    
    var firstDate: Date? {
        date(from: [.year, .month])
    }
    
    var lastDate: Date? {
        guard let firstDate = firstDate else { return nil }
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: firstDate)
    }
    
    var converted: Date {
        guard let sourceOffset = TimeZone(abbreviation: "UTC")?.secondsFromGMT(for: self) else { return self }
        let destinationOffset = TimeZone.current.secondsFromGMT(for: self)
        
        return Date(timeInterval: TimeInterval(destinationOffset - sourceOffset), since: self)
    }
}

extension Date {
    
    init(millisecondsIntervalSince1970  milliseconds: Double) {
        self.init(timeIntervalSince1970: milliseconds / 1000)
    }
}

extension Date {
    
    /// Return truncated date
    func date(from components: Set<Calendar.Component>, timeZone: TimeZone? = .current) -> Date? {
        guard let timeZone = timeZone else { return nil }

        var calendar = Calendar.current
        calendar.timeZone = timeZone
        calendar.locale   = .current
        
        var dateComponents = calendar.dateComponents(components, from: self)
        dateComponents.timeZone = timeZone
        
        return Calendar.current.date(from: dateComponents)
    }
    
    func date(seconds: Int) -> Date? {
        Calendar.current.date(byAdding: DateComponents(second: seconds), to: self)
    }
    
    func date(minutes: Int) -> Date? {
        Calendar.current.date(byAdding: DateComponents(minute: minutes), to: self)
    }
    
    func date(hours: Int) -> Date? {
        Calendar.current.date(byAdding: DateComponents(hour: hours), to: self)
    }
    
    func date(days: Int) -> Date? {
        Calendar.current.date(byAdding: DateComponents(day: days), to: self)
    }
    
    func date(weeks: Int) -> Date? {
        Calendar.current.date(byAdding: DateComponents(day: weeks * 7), to: self)
    }
    
    func date(months: Int) -> Date? {
        Calendar.current.date(byAdding: DateComponents(month: months), to: self)
    }
    
    func date(years: Int) -> Date? {
        Calendar.current.date(byAdding: DateComponents(year: years), to: self)
    }
    
    func seconds(from: Date?) -> Int? {
        guard let from = from else { return nil }
        return Calendar.current.dateComponents([.second], from: from, to: self).second
    }
    
    func minutes(from: Date?) -> Int? {
        guard let from = from else { return nil }
        return Calendar.current.dateComponents([.minute], from: from, to: self).minute
    }
    
    func days(from: Date?) -> Int? {
        guard let from = from else { return nil }
        
        var calendar = Calendar.current
        calendar.timeZone = .current
        calendar.locale   = .current
        
        // Replace the hour (time) of both dates with 00:00
        let toDay   = calendar.startOfDay(for: self)
        let fromDay = calendar.startOfDay(for: from)
        
        return calendar.dateComponents([.day], from: fromDay, to: toDay).day
    }
    
    func months(from: Date?) -> Int? {
        guard let from = from else { return nil }
        
        var calendar = Calendar.current
        calendar.timeZone = .current
        calendar.locale   = .current
        
        // Replace the hour (time) of both dates with 00:00
        guard let toDay = calendar.startOfDay(for: self).lastDate, let fromDay = calendar.startOfDay(for: from).firstDate else { return nil }
        return calendar.dateComponents([.month], from: fromDay, to: toDay).month
    }
    
    func years(from: Date?) -> Int? {
        guard let from = from else { return nil }
        
        var calendar = Calendar.current
        calendar.timeZone = .current
        calendar.locale   = .current
        
        // Replace the hour (time) of both dates with 00:00
        let toDay   = calendar.startOfDay(for: self)
        let fromDay = calendar.startOfDay(for: from)
        
        return calendar.dateComponents([.year], from: fromDay, to: toDay).year
    }
    
    func compare(date: Date, components: Set<Calendar.Component>, timeZone: TimeZone? = .current) -> ComparisonResult {
        guard let timeZone = timeZone else { return .orderedSame }

        var calendar = Calendar.current
        calendar.timeZone = timeZone
        calendar.locale   = .current
        
        let sourceDateComponents = calendar.dateComponents(components, from: self)
        let targetDateComponents = calendar.dateComponents(components, from: date)
        
        guard let sourceDate = calendar.date(from: sourceDateComponents), let targetDate = calendar.date(from: targetDateComponents) else { return .orderedSame }
        
        return sourceDate.compare(targetDate)
    }
    
    func loacalizedFormattedString(dateFormat: DateFormat) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate(dateFormat.rawValue)
        return dateFormatter.string(from: self)
    }
    
    /// Default (locale : "currrent", timeZone : "current")
    func string(dateFormat: DateFormat, locale: Locale? = .current, timeZone: TimeZone? = .current) -> String? {
        string(dateFormat: dateFormat.rawValue, locale: locale, timeZone: timeZone)
    }
    
    /// Default (locale : "currrent", timeZone : "current")
    func string(dateFormat: String, locale: Locale? = .current, timeZone: TimeZone? = .current) -> String? {
        guard let locale = locale, let timeZone = timeZone else {
            log(.error, "Failed to convert date to string.")
            return nil
        }
        
        // Set formatter
        let dateFormatter        = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.locale     = locale
        dateFormatter.timeZone   = timeZone
        
        let dateString = dateFormatter.string(from: self)
        return dateString == "" ? nil : dateString
    }
    
    func convert(source: TimeZone? = TimeZone(abbreviation: "UTC"), target: TimeZone? = .current) -> Date {
        guard let sourceOffset = source?.secondsFromGMT(for: self), let destinationOffset = target?.secondsFromGMT(for: self) else { return self }
        return Date(timeInterval: TimeInterval(destinationOffset - sourceOffset), since: self)
    }
}
