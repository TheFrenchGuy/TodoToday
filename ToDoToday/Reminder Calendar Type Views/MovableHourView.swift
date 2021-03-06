//
//  MovableHourView.swift
//  ToDoToday
//
//  Created by Noe De La Croix on 23/08/2021.
//

import SwiftUI
import Foundation

struct MovableHourView: View {
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(entity: DrawingCanvas.entity(), sortDescriptors: []) var drawings: FetchedResults<DrawingCanvas>
    
    
    
    @State private var location: CGPoint = CGPoint(x: 100, y: 250)
    @GestureState private var fingerLocation: CGPoint? = nil
    @GestureState private var startLocation: CGPoint? = nil // 1
    
    @Binding var refreshList: Bool
    var TimeUUID: UUID
    var heightTime: CGFloat
    var startTime: Date
    var timeIntervalSinceStartTimeandEndTime: Double
    var horizontalPlacement: Double
    var typeREM: String
    @Binding var windowSize: CGSize
    
    
    var simpleDrag: some Gesture {
           DragGesture()
               .onChanged { value in
                   var newLocation = startLocation ?? location // 3
                   newLocation.x += value.translation.width
                   newLocation.y += value.translation.height
                   print(getHeightFromTop(height: value.translation.height))
                if value.translation.height == 27.0 {
                        print("15min")
                    }
                   self.location = newLocation
               }.updating($startLocation) { (value, startLocation, transaction) in
                   startLocation = startLocation ?? location // 2
               }
            .onEnded() {value in
                newStoredLocation(currentUUID: TimeUUID, newLocation: location)
            }
       }
       
       var fingerDrag: some Gesture {
           DragGesture()
               .updating($fingerLocation) { (value, fingerLocation, transaction) in
                   fingerLocation = value.location
               }
       }
    
    
    
    
    
    var body: some View {
        
        GeometryReader { bounds in
            ZStack {
                HoursView(RefreshList: $refreshList, TimeUUID: TimeUUID, heightTime: heightTime)
                .frame(width: 100, height: heightTime)
                .position(location)
                .gesture(
                    simpleDrag.simultaneously(with: fingerDrag)
                    
                )
//                .onChange(of: location, perform: { value in
//                    newStoredLocation(currentUUID: TimeUUID, newLocation: location)
//                })
                
                if let fingerLocation = fingerLocation {
                    Circle()
                        .stroke(Color.green, lineWidth: 2)
                        .frame(width: 44, height: 44)
                        .position(fingerLocation)
                }
            }.onAppear(perform: {location = gettimelocation(hour: startTime, xlocation: horizontalPlacement, type: typeREM, size: windowSize)})
//            .onRotate(perform: {newOrientation in
//                location = gettimelocation(hour: startTime, xlocation: horizontalPlacement, type: typeREM, size: windowSize)
//
//            })
            .onChange(of: UIDevice.current.orientation, perform: { value in
                location = gettimelocation(hour: startTime, xlocation: horizontalPlacement, type: typeREM, size: UIScreen.main.bounds.size)
            })
        }
        
        
    }
    
    func gettimelocation(hour: Date, xlocation: Double, type: String, size: CGSize) -> CGPoint{
        
        let date: Date = (Calendar.current.date(bySettingHour: 0, minute: 0, second: 0 , of: Date())!)
        
        var ylocation = 0.0
        var locationHorizontal = 0.0
        locationHorizontal = xlocation
       
        var whichhour = 0.0
//        ylocation = Double((108 * hour) + 61)
        whichhour = hour.timeIntervalSince(date) / 3600
        
        if whichhour > 24 {
            return CGPoint(x: 0, y: 0)
        } else {
            
         
            ylocation = Double((108 * whichhour) + 61)


            
            
            print("Size width: \(size.width), \(locationHorizontal)")
            
            
            if size.width <= CGFloat(locationHorizontal) {
                locationHorizontal = Double(size.width - 100)
//                print("Size w after \(locationHorizontal)")
        
            }
            
             
            
            
            
            
            return CGPoint(x: locationHorizontal, y: ylocation)
        }
    }
    
    
    func newStoredLocation(currentUUID: UUID, newLocation: CGPoint) {
        
        for drawing in drawings {
            if drawing.id == currentUUID {
                drawing.xLocation = Double(newLocation.x)
                drawing.yLocation = Double(newLocation.y)
                drawing.startTime = getNewStartTimeLocation(yAxis: newLocation.y)
                drawing.endTime = drawing.startTime?.addingTimeInterval(timeIntervalSinceStartTimeandEndTime)
                registerNotificationAlert(title: drawing.title ?? "NO TITLE", body: "Check your task", startTime: getNewStartTimeLocation(yAxis: newLocation.y) , offset: getOffset(nameDesc: drawing.alertNotificationTimeBefore ?? "At time of event"), id: drawing.id ?? UUID())
                do {
                    try viewContext.save()
                  //  try viewContext.refreshAllObjects()
                    
                }
                catch{
                    print(error)
                    print("ERROR COULDNT ADD ITEM")
                }
            }
        }
    }
    
    func getNewStartTimeLocation(yAxis: CGFloat) -> Date {
        let dayConversion = ((yAxis -  61) / 2592)
        let numOfSeconds: Double = Double(dayConversion) * 86400
        
        let hours = Int(numOfSeconds / 3600)
        let minutes = Int(Int(numOfSeconds) - (hours * 3600)) / 60
        let seconds = Int(Double(numOfSeconds) - Double(hours * 3600) - Double(minutes * 60))
        
        
        
        let newStartTime: Date = (Calendar.current.date(bySettingHour: hours, minute: minutes, second: seconds, of: Date()) ?? Date())
        
        return newStartTime
    }
    
    func getHeightFromTop(height: CGFloat) -> CGFloat {
        let offset = location.y + height
        
        return (offset)
    }
    
    
    
    func getOffset(nameDesc: String) -> Int {
        if nameDesc == "At time of event" {
            return 0
        }
        if nameDesc == "5 minutes before" {
            return 300
        }
        
        if nameDesc == "10 minutes before" {
            return 600
        }
        
        if nameDesc == "15 minutes before" {
            return 900
        }
        if nameDesc == "30 minutes before" {
            return 1800
        }
        
        if nameDesc == "1 hour before" {
            return 3600
        }
        
        if nameDesc == "2 hours before" {
            return 7200
        }
        
        return 0
    }
    
    func registerNotificationAlert(title: String, body: String, startTime: Date, offset: Int, id: UUID) {
        let content = UNMutableNotificationContent()
        let userNotificationCenter = UNUserNotificationCenter.current()
        var offsethour = 0
        var offsetminutes = 0
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default
        
        var dateInfo = DateComponents()
        
        if offset >= 3600 {
            offsethour = Int(offset / 3600)
            offsetminutes = offset - (offsethour * 3600)
        } else {
            offsetminutes = offset
        }
        dateInfo.hour = (Int(startTime.toString(dateFormat: "HH")) ?? 0) - (offsethour)
        dateInfo.minute = (Int(startTime.toString(dateFormat: "mm")) ?? 0) - (offsetminutes / 60)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: false)
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: id.uuidString, content: content, trigger: trigger)
//        let request = UNNotificationRequest(identifier: "testNotification",
//                                            content: content,
//                                                trigger: trigger)
        
        userNotificationCenter.add(request) { (error) in
            if let error = error {
                print("Notification Error: ", error)
            }
        }
        
//        print("Added Notification \(dateInfo.hour), \(dateInfo.minute)")
    }
    
}

//struct MovableHourView_Previews: PreviewProvider {
//    static var previews: some View {
//        MovableHourView()
//    }
//}
