//
//  CalendarView.swift
//  ToDoToday
//
//  Created by Noe De La Croix on 25/07/2021.
//

import SwiftUI




struct CalendarView: View {
    @Binding var RefreshList: Bool
    
    @FetchRequest(entity: DrawingCanvas.entity(), sortDescriptors: []) var drawings: FetchedResults<DrawingCanvas>
    
    
    @EnvironmentObject var hourOfDay: HourOfDay
    
    //@State private var location: CGPoint = CGPoint(x: 50, y: 50)
    let date: Date = (Calendar.current.date(bySettingHour: 0, minute: 0, second: 0 , of: Date())!)
    
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
//                                    gettimelocation(height: proxy.size.height , hour: (Calendar.current.date(bySettingHour: 23, minute: 0, second: 0 , of: Date())!))
                                }
                            }
                        )
                        
                        ForEach(drawings, id: \.self) {drawing in
                            
                            if (drawing.timeEvent?.timeIntervalSince(date))! > 86400 {
                                EmptyView()
                            } else {
                                HoursView(RefreshList: $RefreshList, TimeUUID: drawing.id ?? UUID())
                                    .foregroundColor(.pink)
                                    .frame(width: 100, height: 100)
                                    .position(gettimelocation(height: CGFloat(12), hour: drawing.timeEvent ?? Date()))
                            }
                        }
                    }
                }
            }
        }
    }
    
    func gettimelocation(height: CGFloat, hour: Date) -> CGPoint{
        var ylocation = 0.0
        var whichhour = 0.0
//        ylocation = Double((108 * hour) + 61)
        whichhour = hour.timeIntervalSince(date) / 3600
        
        if whichhour > 24 {
            return CGPoint(x: 0, y: 0)
        } else {
        print(whichhour)
        ylocation = Double((108 * whichhour) + 61)
        print(ylocation)
        
        
//        location.y = CGFloat(ylocation)
        return CGPoint(x: 100, y: ylocation)
        }
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
                                Text("24:00").padding(.trailing, 10)
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

