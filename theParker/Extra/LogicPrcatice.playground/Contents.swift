import UIKit

let date = Date()
let formatter = DateFormatter()

formatter.dateFormat = "dd-MM-yyyy h:mm a"

let dateNow_string = formatter.string(from: date)
let dateNow = formatter.date(from: dateNow_string)

let date2 = dateNow!.addingTimeInterval(60.0 * 60.0)
let date2_string = formatter.string(from: date2)


//Comparision
let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd-MM-yyyy h:mm a"
    formatter.timeZone = TimeZone.current
    return formatter
} ()

extension Date {
    func secondsFromBeginningOfTheDay() -> TimeInterval {
        let calendar = Calendar.current
        // omitting fractions of seconds for simplicity
        let dateComponents = calendar.dateComponents([.hour, .minute, .second], from: self)

        let dateSeconds = dateComponents.hour! * 3600 + dateComponents.minute! * 60 + dateComponents.second!

        return TimeInterval(dateSeconds)
    }

    // Interval between two times of the day in seconds
    func timeOfDayInterval(toDate date: Date) -> TimeInterval {
        let date1Seconds = self.secondsFromBeginningOfTheDay()
        let date2Seconds = date.secondsFromBeginningOfTheDay()
        return date2Seconds - date1Seconds
    }
}

do {
    let diff = dateNow!.timeOfDayInterval(toDate: date2)

    // as text
    if diff > 0 {
        print("Time of the day in the second date is greater")
    } else if diff < 0 {
        print("Time of the day in the first date is greater")
    } else {
        print("Times of the day in both dates are equal")
    }


    // show interval as as H M S
    let timeIntervalFormatter = DateComponentsFormatter()
    timeIntervalFormatter.unitsStyle = .abbreviated
    timeIntervalFormatter.allowedUnits = [.hour, .minute, .second]
    print("Difference between times since midnight is", timeIntervalFormatter.string(from: diff) ?? "n/a")

}
