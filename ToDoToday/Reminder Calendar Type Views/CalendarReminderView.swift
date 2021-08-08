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
    
    @State var childSize: CGSize = .zero
    
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
            
            ZStack(alignment: .topLeading) {
                
                NavigationView {
                        ZStack {
                            HStack {
                                if self.tabViewClass.showTab == true {
                                    SideBarView().environment(\.managedObjectContext, colorPalettePersistance.container.viewContext)
                                        
                                        .frame(width: geometry.size.width/3, height: geometry.size.height - childSize.width)
                                        .background(Color("lightFormGray").edgesIgnoringSafeArea(.all))
                                        .transition(.move(edge: .leading))
                                        .onAppear(perform: {
                                            print("SIZE OF CHILD \(self.childSize.width)")
                                        })
                                        
                                        
                                        
                                }
                                
                                if self.tabViewClass.showTask {
                                    Text("TO BE IMPLEMENT TO SHOW THE TASK FROM THE PAST DAYS")
                                        .frame(width: geometry.size.width/3, height: geometry.size.height)
                                }
                                
                                
                                TodayCanvasView()
                            }
                        }
                        .gesture(drag)
                        .navigationBarItems(leading: TabTaskPlusView().frame(height: 60), trailing: TodaySettingsView())
                    }
                        .navigationViewStyle(StackNavigationViewStyle())
                
                
            
                
                
                
            }
        }.onPreferenceChange(SizePreferenceKey.self) { preferences in
            if preferences == CGSize(width: 0, height: 0){
                self.childSize = CGSize(width: 54.0, height: 54.0)
            } else {
            self.childSize = preferences
            }
        }
        .environmentObject(tabViewClass)
        
        
    }
    
}

struct CalendarReminderView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarReminderView()
    }
}








