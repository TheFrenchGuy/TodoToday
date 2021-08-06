//
//  CalendarReminderView.swift
//  ToDoToday
//
//  Created by Noe De La Croix on 21/07/2021.
//

import SwiftUI
import Combine
import Foundation

class TabViewClass: ObservableObject{
    @Published var showTab = false
    @Published var showTask = false
    @Published var addNewTask = false
}

struct CalendarReminderView: View {
   
    
    @State private var showTab = false
    @State private var showTask = false
    @State private var addNewTask  = false
    
    @StateObject var tabViewClass = TabViewClass()
    
    @State private var AddedNewCanvas: Bool = false
    
    var body: some View {
        
        
        let drag = DragGesture() //MARK: TO implement the drag gestures to open and close the menu
            .onEnded {
                if $0.translation.width < -100 {
                    withAnimation{self.tabViewClass.showTab = false}
                }
                if $0.translation.width > -100 {
                    withAnimation{self.tabViewClass.showTab = true}
                }
            }
        
        return NavigationView {
            GeometryReader { geometry in
                ZStack {
                    HStack {
                        if self.tabViewClass.showTab == true {
                            SideBarView()
                                .frame(width: geometry.size.width/3)
                                .transition(.move(edge: .leading))
                        }
                        
                        if self.tabViewClass.showTask {
                            Text("TO BE IMPLEMENT TO SHOW THE TASK FROM THE PAST DAYS")
                        }
                        
                        
                        TodayCanvasView()
                    }
                }
                .gesture(drag)
            }
                .navigationBarItems(leading: TodaySettingsView())
        }.navigationViewStyle(StackNavigationViewStyle())
        .environmentObject(tabViewClass)
    }
    
}

struct CalendarReminderView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarReminderView()
    }
}


struct TodaySettingsView: View {
    
    @EnvironmentObject var tabViewClass:TabViewClass
    
    
    
    
    
    
    
    var body: some View {
        
        HStack {
            
            Button(action: {
                
                toggleTabView()
            }) {
                Image(systemName: "sidebar.left").font(.title2)
            }
            
            Button(action: {
                toggleTaskView()
            }) {
                Image(systemName: "archivebox").font(.title2)
            }
            
            Button(action: {
                self.tabViewClass.addNewTask.toggle()
            }) {
                Image(systemName: "plus").font(.title2)
            }
            
            Button(action: {//MARK: will then implement the settings from there
                
            }) {
                Image(systemName: "umbrella").foregroundColor(.gray).font(.title2).padding()
            }
                
            Divider()
            ShowTodayDateView()
        }
        
        
            
    }
    
    func toggleTabView() {
        self.tabViewClass.showTab.toggle()
        
        if self.tabViewClass.showTask == true {
            self.tabViewClass.showTask.toggle()
        }
    }
    
    func toggleTaskView() {
        self.tabViewClass.showTask.toggle()
        
        if self.tabViewClass.showTab == true {
            self.tabViewClass.showTab.toggle()
        }
    }
}

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
        Text("Today is \(datetime)").font(.title2).bold().foregroundColor(.black)
    }
}
