//
//  CalendarView.swift
//  ToDoToday
//
//  Created by Noe De La Croix on 25/07/2021.
//

import SwiftUI




struct CalendarView: View {
//    @Binding var midnight: [UUID]
//    @Binding var oneam: [UUID]
//    @Binding var twoam: [UUID]
//    @Binding var threeam: [UUID]
//    @Binding var fouram: [UUID]
//    @Binding var fiveam: [UUID]
//    @Binding var sixam: [UUID]
//    @Binding var sevenam: [UUID]
//    @Binding var eightam: [UUID]
//    @Binding var nineam: [UUID]
//    @Binding var tenam: [UUID]
//    @Binding var elevenam: [UUID]
//    @Binding var twelveam: [UUID]
//    @Binding var onepm: [UUID]
//    @Binding var twopm: [UUID]
//    @Binding var threepm: [UUID]
//    @Binding var fourpm: [UUID]
//    @Binding var fivepm: [UUID]
//    @Binding var sixpm: [UUID]
//    @Binding var sevenpm: [UUID]
//    @Binding var eightpm: [UUID]
//    @Binding var ninepm: [UUID]
//    @Binding var tenpm: [UUID]
//    @Binding var elevenpm: [UUID]
    
    @Binding var RefreshList: Bool
    
    @EnvironmentObject var hourOfDay: HourOfDay
    
    var body: some View {
        ZStack {
            GeometryReader { bounds in
                ScrollView {
                    ForEach(1...24, id: \.self) {number in
                        
                        if number == 1 {
                        
                            HoursView(ArrayHourUUID: $hourOfDay.sevenam, ShowTime: "7am", RefreshList: $RefreshList).frame(height: 200)
                            
                            
                        }
                        
                        
                        else if number == 2 {
                            HoursView(ArrayHourUUID: $hourOfDay.eightam, ShowTime: "8am", RefreshList: $RefreshList).frame(height: 200)
                        }
                        else if number == 3{
                            HoursView(ArrayHourUUID: $hourOfDay.nineam, ShowTime: "9am", RefreshList: $RefreshList).frame(height: 200)
                        }
                        else if number == 4 {
                            HoursView(ArrayHourUUID: $hourOfDay.tenam, ShowTime: "10am", RefreshList: $RefreshList).frame(height: 200)
                        }
                        else if number == 5 {
                            HoursView(ArrayHourUUID: $hourOfDay.elevenam, ShowTime: "11am", RefreshList: $RefreshList).frame(height: 200)
                        }
                        else if number == 6 {
                            HoursView(ArrayHourUUID: $hourOfDay.twelveam, ShowTime: "12am", RefreshList: $RefreshList).frame(height: 200)
                        }
                        else if number == 7 {
                            HoursView(ArrayHourUUID: $hourOfDay.onepm, ShowTime: "1pm", RefreshList: $RefreshList).frame(height: 200)
                        }
                        else if number == 8 {
                            HoursView(ArrayHourUUID: $hourOfDay.twopm, ShowTime: "2pm", RefreshList: $RefreshList).frame(height: 200)
                        }
                        else if number == 9 {
                            HoursView(ArrayHourUUID: $hourOfDay.threepm, ShowTime: "3pm", RefreshList: $RefreshList).frame(height: 200)
                        }
                        else if number == 10 {
                            HoursView(ArrayHourUUID: $hourOfDay.fourpm, ShowTime: "4pm", RefreshList: $RefreshList).frame(height: 200)
                        }else if number == 11 {
                            HoursView(ArrayHourUUID: $hourOfDay.fivepm, ShowTime: "5pm", RefreshList: $RefreshList).frame(height: 200)
                        }
                        else if number == 12 {
                            HoursView(ArrayHourUUID: $hourOfDay.sixpm, ShowTime: "6pm", RefreshList: $RefreshList).frame(height: 200)
                            

                        }
                        else if number == 13 {
                            HoursView(ArrayHourUUID: $hourOfDay.sevenpm, ShowTime: "7pm", RefreshList: $RefreshList).frame(height: 200)
                        }
                        else if number == 14 {
                            HoursView(ArrayHourUUID: $hourOfDay.eightpm, ShowTime: "8pm", RefreshList: $RefreshList).frame(height: 200)
                        }
                        else if number == 15 {
                            HoursView(ArrayHourUUID: $hourOfDay.ninepm, ShowTime: "9pm", RefreshList: $RefreshList).frame(height: 200)
                        }
                        else if number == 16 {
                            HoursView(ArrayHourUUID: $hourOfDay.tenpm, ShowTime: "10pm", RefreshList: $RefreshList).frame(height: 200)
                        }
                        else if number == 17 {
                            HoursView(ArrayHourUUID: $hourOfDay.elevenpm, ShowTime: "11pm", RefreshList: $RefreshList).frame(height: 200)
                        }
                        else if number == 18 {
                            HoursView(ArrayHourUUID: $hourOfDay.midnight, ShowTime: "12am", RefreshList: $RefreshList).frame(height: 200)
                        }
                        else if number == 19 {
                            HoursView(ArrayHourUUID: $hourOfDay.oneam, ShowTime: "1am", RefreshList: $RefreshList).frame(height: 200)
                        }
                        else if number == 20 {
                            HoursView(ArrayHourUUID: $hourOfDay.twoam, ShowTime: "2am", RefreshList: $RefreshList).frame(height: 200)
                        }
                        else if number == 21 {
                            HoursView(ArrayHourUUID: $hourOfDay.threeam, ShowTime: "3am", RefreshList: $RefreshList).frame(height: 200)
                        }
                        else if number == 22 {
                            HoursView(ArrayHourUUID: $hourOfDay.fouram, ShowTime: "4am", RefreshList: $RefreshList).frame(height: 200)
                        }
                        else if number == 23 {
                            HoursView(ArrayHourUUID: $hourOfDay.fiveam, ShowTime: "5am", RefreshList: $RefreshList).frame(height: 200)
                        }
                        else if number == 24 {
                            HoursView(ArrayHourUUID: $hourOfDay.sixam, ShowTime: "6am", RefreshList: $RefreshList).frame(height: 200)
                        }
                        
                        


                    }
                }
            }
        }
    }
}

//struct CalendarView_Previews: PreviewProvider {
//    static var previews: some View {
//        CalendarView()
//    }
//}
