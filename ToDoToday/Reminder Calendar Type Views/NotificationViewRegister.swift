//
//  NotificationViewRegister.swift
//  ToDoToday
//
//  Created by Noe De La Croix on 03/09/2021.
//

import SwiftUI

struct NotificationViewRegister: View {
    
    
    @Environment(\.managedObjectContext) private var viewContext


    @FetchRequest(entity: NotificationsDays.entity(), sortDescriptors: []) var notificationsDays: FetchedResults<NotificationsDays>
    
    
    var body: some View {
        Text("Notification View") // This view should techincally never be displayed
            .onAppear(perform: {
                registerDailyNotifications()
                print("Added Notification")
            })
    }
    
    func registerDailyNotifications() {
        for notificationDay in notificationsDays {
            let content = UNMutableNotificationContent()
            let userNotificationCenter = UNUserNotificationCenter.current()
            content.title = "Its \(notificationDay.day!) \(notificationDay.time?.toString(dateFormat: "HH:mm") ?? "09:01") "
            content.body = "Its time to add your tasks for the day"

            var dateInfo = DateComponents()
//            dateInfo.weekday = Int(notificationDay.dayOfWeek)
//            dateInfo.hour = Int(notificationDay.hourOfWeek)
//            dateInfo.minute = Int(notificationDay.minuteOfWeek)
            print("WEEK DAY: \(notificationDay.day) \(notificationDay.time?.toString(dateFormat: "EEEE"))")
            
            
            if notificationDay.day! == "Monday" {
                dateInfo.weekday = 2
            }
            if notificationDay.day! == "Tuesday" {
                dateInfo.weekday = 3
            }
            
            if notificationDay.day! == "Wednesday" {
                dateInfo.weekday = 4
            }
            
            if notificationDay.day! == "Thursday" {
                dateInfo.weekday = 5
            }
            if notificationDay.day! == "Friday" {
                dateInfo.weekday = 6
            }
            
            if notificationDay.day! == "Saturday" {
                dateInfo.weekday = 7
            }
            
            if notificationDay.day! == "Sunday" {
                dateInfo.weekday = 1
            }
//            dateInfo.weekday = Int((notificationDay.time?.toString(dateFormat: "e"))!)
            dateInfo.hour = Int((notificationDay.time?.toString(dateFormat: "HH") ?? "09"))
            dateInfo.minute = Int((notificationDay.time?.toString(dateFormat: "mm" ) ?? "01"))

            
                if !notificationDay.shouldBeAlerted {
                    userNotificationCenter.getPendingNotificationRequests { (notificationRequests) in
                        for _:UNNotificationRequest in notificationRequests {
                            userNotificationCenter.removePendingNotificationRequests(withIdentifiers: [notificationDay.day ?? "NO TIME"])
                        }
                    }
                } else {
                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: true)
                    let request = UNNotificationRequest(identifier: notificationDay.day ?? "NO TIME", content: content, trigger: trigger)
                    
                    
                    

                    userNotificationCenter.add(request) { (error) in
                        if let error = error {
                            print("Notification Error: ", error)
                        }
                    }
                }
            }
            


    }
    
    
    
}

struct NotificationViewRegister_Previews: PreviewProvider {
    static var previews: some View {
        NotificationViewRegister()
    }
}
