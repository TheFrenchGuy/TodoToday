//
//  CalendarReminderView.swift
//  ToDoToday
//
//  Created by Noe De La Croix on 21/07/2021.
//

import SwiftUI
import Combine
import Foundation
import SwiftUINavigationBarColor

class TabViewClass: ObservableObject{
    @Published var showTab = false
    @Published var showTask = false
    @Published var addNewTask = false
    @Published var editTask = false
    @Published var editTaskUUID = UUID()
    @Published var taskType: String = ""
}

struct CalendarReminderView: View {
    
    
    
    @Environment (\.managedObjectContext) var viewContext
   
    @FetchRequest(entity: ColorPalette.entity(), sortDescriptors: []) var colorpalette: FetchedResults<ColorPalette>
    @State private var showTab = false
    @State private var showTask = false
    @State private var addNewTask  = false
    

    
    @StateObject var tabViewClass = TabViewClass()
    
    @State private var AddedNewCanvas: Bool = false
    
    @State var childSize: CGSize = .zero
    
    @State var numberOfTasksAds = UserPreference().numberOfTasksBeforeAds
    
    let colorPalettePersistance = ColorPalettePersistance.shared
    @EnvironmentObject var transferColorPalette:TransferColorPalette
    @EnvironmentObject var showInterstitialAd:ShowInterstitialAdClass
    
    let persistenceController = PersistenceController.shared
    
    
    #if !targetEnvironment(macCatalyst)
    
   
    
    private var fullScreenAd: Interstitial?
       init() {
           fullScreenAd = Interstitial()
            UINavigationBar.appearance().backgroundColor = UIColor(named: "lightFormGray")
            UINavigationBar.appearance().isTranslucent = false
            UINavigationBar.appearance().barTintColor = UIColor(named: "lightFormGray")
       }
    
    #else
        init() { //Required to make the top bar to be gray
            UINavigationBar.appearance().backgroundColor = UIColor(named: "lightFormGray")
            UINavigationBar.appearance().isTranslucent = false
            UINavigationBar.appearance().barTintColor = UIColor(named: "lightFormGray")
           
            
        }
    #endif
   
        
        
    
    
    
  
    
    
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
                                            
                                            .frame(width: (geometry.size.width / 3), height: (geometry.size.height - childSize.height))
                                            .padding(.top, childSize.height)
                                            .background(Color("lightFormGray").edgesIgnoringSafeArea(.all))
                                            .transition(.move(edge: .leading))
                                            .onAppear(perform: {
                                                print("SIZE OF CHILD \(self.childSize.width)")
                                            })
                                            .zIndex(1)
                                            
                                            
                                            
                                    }
                                    
                                    if self.tabViewClass.showTask {
                                        TaskNotDoneFromPreviousDayView().environment(\.managedObjectContext, persistenceController.container.viewContext)
    //                                    Text("TO BE IMPLEMENT TO SHOW THE TASK FROM THE PAST")
                                            .frame(width: geometry.size.width/3, height: geometry.size.height - childSize.width)
                                            .padding(.top, childSize.height)
                                            .background(Color("lightFormGray").edgesIgnoringSafeArea(.all))
                                            .transition(.move(edge: .leading))
                                    }
                                    
                                    
                                    TodayCanvasView().environment(\.managedObjectContext, persistenceController.container.viewContext)
//                                        .frame(height: geometry.size.height - childSize.height)
//                                        .padding(.top, childSize.height)
                                            

                                        
                                        .onTapGesture(perform: {
                                            if self.tabViewClass.editTask { //So that you can click out at any time
                                                self.tabViewClass.editTask = false
                                            }
                                            
                                            if self.numberOfTasksAds >= 3 {
                                           
                                                               #if !targetEnvironment(macCatalyst)
                                                                   self.fullScreenAd?.showAd()
                                                                   #endif
                                                                   self.showInterstitialAd.InterstitialAdShow = false
                                                
                                                UserDefaults.standard.set(0, forKey: "numberOfTasksBeforeAds")
                                                self.numberOfTasksAds = 0
                                                               }
                                        })
                                        .onAppear(perform: {print("Number of Tasks before ads \(numberOfTasksAds)")})
                                    
                                    
                                    if self.tabViewClass.editTask {
                                        
                                        if self.tabViewClass.taskType == TypeReminder.typed.rawValue {
                                        EditTaskViewSideBarTyped().frame(width: geometry.size.width/3, height: geometry.size.height - childSize.height)
                                            .padding(.top, childSize.height)
                                        
                                            .transition(.move(edge: .leading))
                                            .environment(\.managedObjectContext, persistenceController.container.viewContext)
                                        }
                                        
                                        if self.tabViewClass.taskType == TypeReminder.audio.rawValue {
                                            EditTaskViewSideBarAudio().frame(width: geometry.size.width/3, height: geometry.size.height - childSize.height)
                                                .padding(.top, childSize.height)
                                            
                                                .transition(.move(edge: .leading))
                                                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                                        }
                                    }
                                }
                            }
                            .gesture(drag)
                            
                        
                            
                            .navigationBarTitleDisplayMode(.inline) //So that it doesnt show the title and doesnt take more space than needed
                            .navigationBarItems(leading: TabTaskPlusView(), trailing: TodaySettingsView())
                            
//                            .navigationTitle("NO TITLE")
//                            .navigationBarHidden(true)
                            
                            
                        }
                            .navigationViewStyle(StackNavigationViewStyle())
//                            .navigationBarBackground {
//                                Color("lightFormGray").shadow(radius: 1) // don't forget the shadow under the opaque navigation bar
//                            }
                            .onAppear{loadInitialColorPalette()}
                    
                
                    
                    
                    
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
    
    func loadInitialColorPalette() {
        transferColorPalette.colorpla.removeAll()
       // transferColorPalette.colorpla.title.removeAll()
        
        
        for color in colorpalette {
//            transferColorPalette.title.append(color.name!)
//            transferColorPalette.color.append(color.paletteColor!.color)
            
            transferColorPalette.colorpla.append(ColorPaletteTemp(id: color.id!, title: color.name!, color: color.paletteColor!.color,isMarked: color.isMarked))
        }
        
        print("Assigned variables")
    }
    
    
    
}

struct CalendarReminderView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarReminderView()
    }
}








