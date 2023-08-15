
import Foundation

/// An extension on `Date` providing utility methods for date manipulation.
extension Date {
    
    /// Returns a new date by adding a specified number of days to the current date.
    ///
    /// - Parameter numDays: The number of days to add to the current date.
    /// - Returns: A new `Date` representing the result of the addition.
    func diff(numDays: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: numDays, to: self)!
    }
    /// Returns the start of the current date, ignoring the time components.
    ///
    /// - Returns: A new `Date` representing the start of the day.
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }
}
