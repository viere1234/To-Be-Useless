//
//  ContentView.swift
//  To-be Useless
//
//  Created by 張智堯 on 2021/7/19.
//

import SwiftUI
import UserNotifications

struct ContentView: View {
    
    @AppStorage("First") var first = true
    @AppStorage("Notification") var isNotification = true
    @AppStorage("MissionStartTime") var missionStartTime = Calendar.current.nextDate(after: Date(), matching: .init(hour: 8), matchingPolicy: .strict)!
    
    var body: some View {
        
        if first {
            FirstView()
        } else {
            TaskListView()
                .onAppear(perform: {
                    if isNotification {
                        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])  { success, error in
                            if success {
                                print("authorization granted")
                                let userHour = Calendar.current.dateComponents([.hour], from: missionStartTime).hour ?? 0
                                let userMinute = Calendar.current.dateComponents([.minute], from: missionStartTime).minute ?? 0
                                DailyNotify(title: "To-Be Useless", body: "Your daily missions are ready!", hour: userHour, minute: userMinute, id: "To-be_Useless_DailyNotify")
                            } else {
                                print("Error")
                                isNotification = false
                            }
                        }
                    }
                })
        }
    }
}
