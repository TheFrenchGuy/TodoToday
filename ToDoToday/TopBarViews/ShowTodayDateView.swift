//
//  ShowTodayDateView.swift
//  ToDoToday
//
//  Created by Noe De La Croix on 07/08/2021.
//

import SwiftUI

struct ShowTodayDateView: View {
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
        Text("\(datetime)").font(.title2).bold().foregroundColor(.black)
    }
}

struct ShowTodayDateView_Previews: PreviewProvider {
    static var previews: some View {
        ShowTodayDateView()
    }
}
