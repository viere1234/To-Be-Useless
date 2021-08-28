//
//  Notification.swift
//  To-be Useless
//
//  Created by 張智堯 on 2021/8/20.
//

import Foundation
import UserNotifications

func DailyNotify(title: String, body: String, hour: Int, minute: Int, id: String) {
    
    let notificationContent = UNMutableNotificationContent()
    notificationContent.title = title
    notificationContent.body = body
    notificationContent.badge = NSNumber(value: 1)
    notificationContent.sound = .default
                    
    var datComp = DateComponents()
    datComp.hour = hour
    datComp.minute = minute
    let trigger = UNCalendarNotificationTrigger(dateMatching: datComp, repeats: true)
    let request = UNNotificationRequest(identifier: id, content: notificationContent, trigger: trigger)
    UNUserNotificationCenter.current().add(request) { (error : Error?) in
        if let theError = error {
            print(theError.localizedDescription)
        }
    }
}

