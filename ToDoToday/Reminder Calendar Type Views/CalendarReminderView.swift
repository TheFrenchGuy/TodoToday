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
    
    let colorPalettePersistance = ColorPalettePersistance.shared
    
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
        
        return GeometryReader { geometry in
            NavigationView {
                ZStack {
                    HStack {
                        if self.tabViewClass.showTab == true {
                            SideBarView().environment(\.managedObjectContext, colorPalettePersistance.container.viewContext)
                                
                                .frame(width: geometry.size.width/3, height: geometry.size.height)
                                .background(Color("lightFormGray").edgesIgnoringSafeArea(.all))
                                .transition(.move(edge: .leading))
                                
                                
                                
                        }
                        
                        if self.tabViewClass.showTask {
                            Text("TO BE IMPLEMENT TO SHOW THE TASK FROM THE PAST DAYS")
                        }
                        
                        
                        TodayCanvasView()
                    }
                }
                .gesture(drag)
                .navigationBarItems(leading: TabTaskPlusView(), trailing: TodaySettingsView())
            }
                .navigationViewStyle(StackNavigationViewStyle())
                
        }
        .environmentObject(tabViewClass)
        
        
    }
    
}

struct CalendarReminderView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarReminderView()
    }
}








