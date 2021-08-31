//
//  CalendarView.swift
//  ToDoToday
//
//  Created by Noe De La Croix on 25/07/2021.
//

import SwiftUI

class TaskPerHour: ObservableObject {
    @Published var midnight: Int = 0
    @Published var oneam: Int = 0
    @Published var twoam: Int = 0
    @Published var threeam: Int = 0
    @Published var fouram: Int = 0
    @Published var fiveam: Int = 0
    @Published var sixam: Int = 0
    @Published var sevenam: Int = 0
    @Published var eightam: Int = 0
    @Published var nineam: Int = 0
    @Published var tenam: Int = 0
    @Published var elevenam: Int = 0
    @Published var twelveam: Int = 0
    @Published var onepm: Int = 0
    @Published var twopm: Int = 0
    @Published var threepm: Int = 0
    @Published var fourpm: Int = 0
    @Published var fivepm: Int = 0
    
   
    @Published var sixpm: Int = 0
    @Published var sevenpm: Int = 0
    @Published var eightpm: Int = 0
    @Published var ninepm: Int = 0
    @Published var tenpm: Int = 0
    @Published var elevenpm: Int = 0
    
}


struct CalendarView: View {
    @Binding var RefreshList: Bool
    
    @FetchRequest(entity: DrawingCanvas.entity(), sortDescriptors: []) var drawings: FetchedResults<DrawingCanvas>
    
    
    @EnvironmentObject var hourOfDay: HourOfDay
    
    @EnvironmentObject var taskPerHour:TaskPerHour
    
    //@State private var location: CGPoint = CGPoint(x: 50, y: 50)
    let date: Date = (Calendar.current.date(bySettingHour: 0, minute: 0, second: 0 , of: Date())!)
    
    
    
    @State private var location: CGPoint = CGPoint(x: 100, y: 0)
    @GestureState private var fingerLocation: CGPoint? = nil
    @GestureState private var startLocation: CGPoint? = nil // 1
    
    
    
    
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
        GeometryReader {bounds in
            ZStack {
                ScrollView(.vertical) {
                    ZStack {
                        CalendarBackGroundView(width: bounds.size.width).overlay(
                            GeometryReader { proxy in
                                Color.clear.onAppear { print("Height: + \(proxy.size.height) ")
                                }
                            }
                            
                        )
                        
                        ForEach(drawings, id: \.self) {drawing in
                            
                            if (drawing.startTime?.timeIntervalSince(date) ?? 60) > 86400 {
                                EmptyView()
                            } else {
                                
//                                ZStack {
//                                HoursView(RefreshList: $RefreshList, TimeUUID: drawing.id ?? UUID(), heightTime: getheight(startDate: drawing.startTime ?? Date(), endDate: drawing.endTime ?? Date().addingTimeInterval(3600)))
//                                    .frame(width: 100, height: getheight(startDate: drawing.startTime ?? Date(), endDate: drawing.endTime ?? Date().addingTimeInterval(3600)))
//                                    .position(gettimelocation(height: CGFloat(12), hour: drawing.startTime ?? Date(), xlocation: drawing.horizontalPlacement ))
//                                    .gesture(
//                                        simpleDrag.simultaneously(with: fingerDrag)
//                                    )
//
//                                    if let fingerLocation = fingerLocation {
//                                        Circle()
//                                            .stroke(Color.green, lineWidth: 2)
//                                            .frame(width: 44, height: 44)
//                                            .position(fingerLocation)
//                                    }
//                                }
                                MovableHourView(refreshList: $RefreshList, TimeUUID: drawing.id ?? UUID(), heightTime: getheight(startDate: drawing.startTime ?? Date(), endDate: drawing.endTime ?? Date().addingTimeInterval(3600)), startTime: drawing.startTime ?? Date(),timeIntervalSinceStartTimeandEndTime: drawing.endTime?.timeIntervalSince(drawing.startTime ?? Date()) ?? 3600 ,horizontalPlacement: drawing.xLocation , typeREM: drawing.typeRem ).zIndex(1)
                            }
                        }
                    }
                }
            }        }
    }
    
    func gettimelocation(height: CGFloat, hour: Date, xlocation: Double, type: String) -> CGPoint{
        var ylocation = 0.0
       
        var whichhour = 0.0
//        ylocation = Double((108 * hour) + 61) That is the orignal location, only works so far for drawings
        whichhour = hour.timeIntervalSince(date) / 3600
        
        if whichhour > 24 {
            return CGPoint(x: 0, y: 0)
        } else {
        ylocation = Double((108 * whichhour) + 61)
      //  print(ylocation)

        return CGPoint(x: xlocation, y: ylocation)
        }
    }
    
    func getheight(startDate: Date, endDate: Date) -> CGFloat{
        let timediff = endDate.timeIntervalSince(startDate)
        let numHour: Double = timediff / 3600

        var height = 0.0
        height = numHour * 108
        return CGFloat(height)
        
        
    }
        
}

//struct CalendarView_Previews: PreviewProvider {
//    static var previews: some View {
//        CalendarView()
//    }
//}
struct CalendarBackGroundView: View {
    
    let nowToday: Date = Date()
    let date: Date = (Calendar.current.date(bySettingHour: 0, minute: 0, second: 0 , of: Date())!)
    let width: CGFloat
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var ylocationbar: CGFloat = 0
    
   
    var body: some View {
        
        ZStack(alignment: .top) {
            
            ZStack(alignment: .leading) {
                Circle().foregroundColor(.red).frame(width: 7, height: 7).padding(.leading, 10)
                VStack {
                   // Divider()
                    RoundedRectangle(cornerRadius: 10).foregroundColor(.red).opacity(0.6).frame(height: 3)
                }
            }.position(x: width / 2, y: ylocationbar)
                .onAppear(perform: {gettimelocation(hour: nowToday)})
                .onReceive(timer, perform: {input in
                    gettimelocation(hour: nowToday)
                })
               
                .zIndex(1)
            VStack {
                ForEach(0...24, id: \.self) { num in
                    
                    ZStack {
                    if num < 10{
                        
                        AMCalendarBackgroundView(num: num)
                            
                        
                    } else if num == 24 {
                        VStack(spacing: 0) {
                            HStack() {
                                Text("00:00").padding(.trailing, 10)
                                VStack {
                                Divider()
                                }
                            }
                                Spacer()
                        }.frame(height: 30)
                    } else if num > 9 && num < 24 {
                        PMCalendarBackgroundView(num: num)
                    }
                                    
                    }
                }
            }
        }
    }
    
    func gettimelocation(hour: Date) {
        var ylocation = 0.0
       
        var whichhour = 0.0
//        ylocation = Double((108 * hour) + 61)
        whichhour = hour.timeIntervalSince(date) / 3600
        
        if whichhour > 24 {
            ylocationbar = CGFloat(0)
        } else {
        ylocation = Double((108 * whichhour) + 10)
      //  print(ylocation)

        ylocationbar = CGFloat(ylocation)
        }
    }
    
    
}



struct AMCalendarBackgroundView: View {
    
    var num: Int
    var body: some View {
        VStack(spacing: 0) {
            HStack() {
                Text("0\(num):00").padding(.trailing, 10)
                
                VStack {
                    Divider()
                }
               
            }
            Spacer()
            
                
            }.frame(height: 100)
    }
}

struct PMCalendarBackgroundView: View {
    var num: Int
    var body: some View {
        VStack(spacing: 0) {
            HStack() {
                Text("\(num):00").padding(.trailing, 10)
                
                VStack {
                    Divider()
                }
               
            }
            Spacer()
            
                
            }.frame(height: 100)
    }
}
