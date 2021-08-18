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
    
    
    @State private var sixpm: Double = 0.0
    
    
    
    var body: some View {
//        ZStack {
//            GeometryReader { bounds in
//                ScrollView {
//                    ForEach(1...24, id: \.self) {number in
//
//                        if number == 1 {
//                            HoursView(ArrayHourUUID: $hourOfDay.sevenam, ShowTime: "7am", RefreshList: $RefreshList).frame(height: 200)
//
//
//
//                        }
//
//
//                        else if number == 2 {
//                            HoursView(ArrayHourUUID: $hourOfDay.eightam, ShowTime: "8am", RefreshList: $RefreshList).frame(height: 200)
//                        }
//                        else if number == 3{
//                            HoursView(ArrayHourUUID: $hourOfDay.nineam, ShowTime: "9am", RefreshList: $RefreshList).frame(height: 200)
//                        }
//                        else if number == 4 {
//                            HoursView(ArrayHourUUID: $hourOfDay.tenam, ShowTime: "10am", RefreshList: $RefreshList).frame(height: 200)
//                        }
//                        else if number == 5 {
//                            HoursView(ArrayHourUUID: $hourOfDay.elevenam, ShowTime: "11am", RefreshList: $RefreshList).frame(height: 200)
//                        }
//                        else if number == 6 {
//                            HoursView(ArrayHourUUID: $hourOfDay.twelveam, ShowTime: "12am", RefreshList: $RefreshList).frame(height: 200)
//                        }
//                        else if number == 7 {
//                            HoursView(ArrayHourUUID: $hourOfDay.onepm, ShowTime: "1pm", RefreshList: $RefreshList).frame(height: 200)
//                        }
//                        else if number == 8 {
//                            HoursView(ArrayHourUUID: $hourOfDay.twopm, ShowTime: "2pm", RefreshList: $RefreshList).frame(height: 200)
//
//                        }
//                        else if number == 9 {
//                            HoursView(ArrayHourUUID: $hourOfDay.threepm, ShowTime: "3pm", RefreshList: $RefreshList).frame(height: 200)
//                        }
//                        else if number == 10 {
//                            HoursView(ArrayHourUUID: $hourOfDay.fourpm, ShowTime: "4pm", RefreshList: $RefreshList).frame(height: 200)
//                        }else if number == 11 {
//                            HoursView(ArrayHourUUID: $hourOfDay.fivepm, ShowTime: "5pm", RefreshList: $RefreshList).frame(height: 200)
//                        }
//                        else if number == 12 {
//                            HoursView(ArrayHourUUID: $hourOfDay.sixpm, ShowTime: "6pm", RefreshList: $RefreshList).frame(height: 200)
//
//
//                        }
//                        else if number == 13 {
//                            HoursView(ArrayHourUUID: $hourOfDay.sevenpm, ShowTime: "7pm", RefreshList: $RefreshList).frame(height: 200)
//                        }
//                        else if number == 14 {
//                            HoursView(ArrayHourUUID: $hourOfDay.eightpm, ShowTime: "8pm", RefreshList: $RefreshList).frame(height: 200)
//                        }
//                        else if number == 15 {
//                            HoursView(ArrayHourUUID: $hourOfDay.ninepm, ShowTime: "9pm", RefreshList: $RefreshList).frame(height: 200)
//                        }
//                        else if number == 16 {
//                            HoursView(ArrayHourUUID: $hourOfDay.tenpm, ShowTime: "10pm", RefreshList: $RefreshList).frame(height: 200)
//
//                        }
//                        else if number == 17 {
//                            HoursView(ArrayHourUUID: $hourOfDay.elevenpm, ShowTime: "11pm", RefreshList: $RefreshList).frame(height: 200)
//                        }
//                        else if number == 18 {
//                            HoursView(ArrayHourUUID: $hourOfDay.midnight, ShowTime: "12am", RefreshList: $RefreshList).frame(height: 200)
//                        }
//                        else if number == 19 {
//                            HoursView(ArrayHourUUID: $hourOfDay.oneam, ShowTime: "1am", RefreshList: $RefreshList).frame(height: 200)
//                        }
//                        else if number == 20 {
//                            HoursView(ArrayHourUUID: $hourOfDay.twoam, ShowTime: "2am", RefreshList: $RefreshList).frame(height: 200)
//                        }
//                        else if number == 21 {
//                            HoursView(ArrayHourUUID: $hourOfDay.threeam, ShowTime: "3am", RefreshList: $RefreshList).frame(height: 200)
//                        }
//                        else if number == 22 {
//                            HoursView(ArrayHourUUID: $hourOfDay.fouram, ShowTime: "4am", RefreshList: $RefreshList).frame(height: 200)
//                        }
//                        else if number == 23 {
//                            HoursView(ArrayHourUUID: $hourOfDay.fiveam, ShowTime: "5am", RefreshList: $RefreshList).frame(height: 200)
//                        }
//                        else if number == 24 {
//                            HoursView(ArrayHourUUID: $hourOfDay.sixam, ShowTime: "6am", RefreshList: $RefreshList).frame(height: 200)
//                        }
//
//
//
//
//                    }
//                }
//            }
//        }
        GeometryReader {bounds in
            ZStack {
                ScrollView(.vertical) {
                    ZStack {
                        CalendarBackGroundView().overlay(
                            GeometryReader { proxy in
                                Color.clear.onAppear { print("Height: + \(proxy.size.height) ")
                                }
                            }
                        )
                        
                        ForEach(drawings, id: \.self) {drawing in
                            
                            if (drawing.startTime?.timeIntervalSince(date) ?? 86401) > 86400 {
                                EmptyView()
                            } else {
                                HoursView(RefreshList: $RefreshList, TimeUUID: drawing.id ?? UUID(), heightTime: getheight(startDate: drawing.startTime ?? Date(), endDate: drawing.endTime ?? Date().addingTimeInterval(3600)))
                                    .foregroundColor(.pink)
                                    .frame(width: 100, height: getheight(startDate: drawing.startTime ?? Date(), endDate: drawing.endTime ?? Date().addingTimeInterval(3600)))
                                    .position(gettimelocation(height: CGFloat(12), hour: drawing.startTime ?? Date(), xlocation: drawing.horizontalPlacement ))
                            }
                        }
                    }
                }
            }        }
    }
    
    func gettimelocation(height: CGFloat, hour: Date, xlocation: Double) -> CGPoint{
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
   
    var body: some View {
        
        
            VStack {
                ForEach(0...24, id: \.self) { num in
                    
                    ZStack {
                    if num < 10{
                        
                        VStack(spacing: 0) {
                            HStack() {
                                Text("0\(num):00").padding(.trailing, 10)
                                
                                VStack {
                                    Divider()
                                }
                               
                            }
                            Spacer()
                            
                                
                            }.frame(height: 100)
                            
                        
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
                }
            }
            
        
    }
}

