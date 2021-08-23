//
//  MovableHourView.swift
//  ToDoToday
//
//  Created by Noe De La Croix on 23/08/2021.
//

import SwiftUI

struct MovableHourView: View {
    
    @State private var location: CGPoint = CGPoint(x: 100, y: 250)
    @GestureState private var fingerLocation: CGPoint? = nil
    @GestureState private var startLocation: CGPoint? = nil // 1
    
    @Binding var refreshList: Bool
    var TimeUUID: UUID
    var heightTime: CGFloat
    var startTime: Date
    var horizontalPlacement: Double
    
    
    
    var simpleDrag: some Gesture {
           DragGesture()
               .onChanged { value in
                   var newLocation = startLocation ?? location // 3
                   newLocation.x += value.translation.width
                   newLocation.y += value.translation.height
                   print(value.translation.height)
                if value.translation.height == 27.0 {
                        print("15min")
                    }
                   self.location = newLocation
               }.updating($startLocation) { (value, startLocation, transaction) in
                   startLocation = startLocation ?? location // 2
               }
       }
       
       var fingerDrag: some Gesture {
           DragGesture()
               .updating($fingerLocation) { (value, fingerLocation, transaction) in
                   fingerLocation = value.location
               }
       }
    
    
    
    
    
    var body: some View {
            ZStack {
                HoursView(RefreshList: $refreshList, TimeUUID: TimeUUID, heightTime: heightTime)
                .frame(width: 100, height: heightTime)
                .position(location)
                .gesture(
                    simpleDrag.simultaneously(with: fingerDrag)
                )
                
                if let fingerLocation = fingerLocation {
                    Circle()
                        .stroke(Color.green, lineWidth: 2)
                        .frame(width: 44, height: 44)
                        .position(fingerLocation)
                }
            }.onAppear(perform: {location = gettimelocation(height: CGFloat(12), hour: startTime, xlocation: horizontalPlacement)})
    }
    
    func gettimelocation(height: CGFloat, hour: Date, xlocation: Double) -> CGPoint{
        
        let date: Date = (Calendar.current.date(bySettingHour: 0, minute: 0, second: 0 , of: Date())!)
        
        var ylocation = 0.0
       
        var whichhour = 0.0
//        ylocation = Double((108 * hour) + 61)
        whichhour = hour.timeIntervalSince(date) / 3600
        
        if whichhour > 24 {
            return CGPoint(x: 0, y: 0)
        } else {
        ylocation = Double((108 * whichhour) + 61)
      //  print(ylocation)

        return CGPoint(x: xlocation, y: ylocation)
        }
    }
    
    
    func newStoredLocation(currentUUID: UUID, newLocation: CGPoint) {
        print("To be implemented later ")
    }
    
}

//struct MovableHourView_Previews: PreviewProvider {
//    static var previews: some View {
//        MovableHourView()
//    }
//}