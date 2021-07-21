//
//  CalendarReminderView.swift
//  ToDoToday
//
//  Created by Noe De La Croix on 21/07/2021.
//

import SwiftUI

struct CalendarReminderView: View {
    let today: Date
    let datetime: String
    
    let formatter: DateFormatter
    init() {
        today = Date()
        formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("EEEE, MMM d") // SHOWs the Weekday in full then month shorttended to 3 Char and the day of it
                            /// Follow the  http://www.unicode.org/reports/tr35/tr35-31/tr35-dates.html#Date_Format_Patterns Date formatter
        datetime = formatter.string(from: today)
    }
    
    
    var body: some View {
        ZStack() {
            GeometryReader { bounds in
                VStack() {
                    HStack() {
                        Button(action: {
                            // MARK: Add the Settings view from there
                            
                        }) {
                            Image(systemName: "umbrella").foregroundColor(.gray).font(.largeTitle).padding()
                        }
                        Divider()
                        Text("Today is \(datetime)").font(.largeTitle).bold().foregroundColor(.black)
                    }.frame(width: bounds.size.width, height: bounds.size.height * 0.05, alignment: .leading)
                        .padding()
                        
                        TodayCanvasView()
                        
                    Spacer()
                }.frame(width: bounds.size.width, height: bounds.size.height, alignment: .center)
            }
        }
    }
}

struct CalendarReminderView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarReminderView()
    }
}
