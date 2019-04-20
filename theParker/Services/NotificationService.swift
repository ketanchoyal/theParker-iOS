//
//  NotificationService.swift
//  theParker
//
//  Created by Ketan Choyal on 20/04/19.
//  Copyright © 2019 Ketan Choyal. All rights reserved.
//

import Foundation
import UserNotifications

class NotificationService {
    static let instance = NotificationService()
    
    let notificationCenter = UNUserNotificationCenter.current()
    let formatter = DateFormatter()
    
    func setNotification(_ title : String, _ body : String, _ time : String, bookedfor hour : String) {
        notificationCenter.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
        }
        
        // Create the notification content
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        
        //Create the notification trigger
//        formatter.dateFormat = "dd-MM-yyyy h:mm a"
//        let d = formatter.date(from: time)
//
//        let bookedFor = Int(hour)
//        let date = d!.addingTimeInterval(bookedFor * 60 * 60)
        let date = Date().addingTimeInterval(10)
        
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        //Create the request
        
        let uuidString = UUID().uuidString
        
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        
        //Register the request
        notificationCenter.add(request) { (error) in
            // Check the error parameter and handle any errors
        }
    }
    
    
    
}

