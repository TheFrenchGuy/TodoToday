//
//  CalendarReminderView_iPhone.swift
//  CalendarReminderView_iPhone
//
//  Created by Noe De La Croix on 01/09/2021.
//

import SwiftUI

struct CalendarReminderView_iPhone: View {
    
    @Environment (\.managedObjectContext) var viewContext
   
    @FetchRequest(entity: ColorPalette.entity(), sortDescriptors: []) var colorpalette: FetchedResults<ColorPalette>
    @State private var showTab = false
    @State private var showTask = false
    @State private var addNewTask  = false
    

    
    @StateObject var tabViewClass = TabViewClass()
    
    @State private var AddedNewCanvas: Bool = false
    
    @State var childSize: CGSize = .zero
    
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
        
        GeometryReader { geometry  in
        ZStack(alignment: .topLeading) {
            NavigationView {
                ZStack {
                    if self.tabViewClass.showTab == true {
                        SideBarView().environment(\.managedObjectContext, colorPalettePersistance.container.viewContext)
                            
                            .frame(width: geometry.size.width, height: geometry.size.height - childSize.height)
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
                            .frame(width: geometry.size.width, height: geometry.size.height - childSize.width)
                            .padding(.top, childSize.height)
                            .background(Color("lightFormGray").edgesIgnoringSafeArea(.all))
                            .transition(.move(edge: .leading))
                            .zIndex(1)
                    }
                    
                    
                    if self.tabViewClass.editTask {
                        
                        if self.tabViewClass.taskType == TypeReminder.typed.rawValue {
                        EditTaskViewSideBarTyped().frame(width: geometry.size.width, height: geometry.size.height - childSize.height)
                            .padding(.top, childSize.height)
                        
                            .transition(.move(edge: .leading))
                            .environment(\.managedObjectContext, persistenceController.container.viewContext)
                            .background(Color(.white).edgesIgnoringSafeArea(.all))
                            .zIndex(1)
                        }
                        
                        if self.tabViewClass.taskType == TypeReminder.audio.rawValue {
                            EditTaskViewSideBarAudio().frame(width: geometry.size.width, height: geometry.size.height - childSize.height)
                                .padding(.top, childSize.height)
                            
                                .transition(.move(edge: .leading))
                                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                                .background(Color(.white).edgesIgnoringSafeArea(.all))
                                .zIndex(1)
                                
                        }
                        
                        if self.tabViewClass.taskType == TypeReminder.image.rawValue {
                            EditTaskViewSideBarImage().frame(width: geometry.size.width, height: geometry.size.height - childSize.height)
                                .padding(.top, childSize.height)
                            
                                .transition(.move(edge: .leading))
                                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                                .background(Color(.white).edgesIgnoringSafeArea(.all))
                                .zIndex(1)
                                
                        }
                        
                        if self.tabViewClass.taskType == TypeReminder.drawing.rawValue {
                            EditTaskViewSideBarDrawing().frame(width: geometry.size.width, height: geometry.size.height - childSize.height)
                                .padding(.top, childSize.height)
                            
                                .transition(.move(edge: .leading))
                                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                                .background(Color(.white).edgesIgnoringSafeArea(.all))
                                .zIndex(1)
                                
                        }
                    }
                    
                    TodayCanvasView_iPhone().environment(\.managedObjectContext, persistenceController.container.viewContext).zIndex(0)
                        .onTapGesture(perform: {
                            if self.tabViewClass.editTask { //So that you can click out at any time
                                self.tabViewClass.editTask = false
                            }
                            
                            if self.showInterstitialAd.InterstitialAdShow {
                           
                                               #if !targetEnvironment(macCatalyst)
                                                   self.fullScreenAd?.showAd()
                                                   #endif
                                                   self.showInterstitialAd.InterstitialAdShow = false
                                               }
                        })

                    
                
                }.navigationBarTitleDisplayMode(.inline) //So that it doesnt show the title and doesnt take more space than needed
                .navigationBarItems(leading: HStack{
                    if self.tabViewClass.editTask {
                        Button(action: {self.tabViewClass.editTask = false}) {
                            Image(systemName: "xmark")
                        }.foregroundColor(.red )
                    }
                },trailing: TabTaskPlusView())
                    .background(NavigationConfigurator { nc in
                        nc.navigationBar.barTintColor = UIColor(named: "lightFormGray")
                                    nc.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.white]
                                })
                
                
            }.navigationViewStyle(StackNavigationViewStyle())
                .onAppear{loadInitialColorPalette()}
                
            }.onPreferenceChange(SizePreferenceKey.self) { preferences in
                if preferences == CGSize(width: 0, height: 0){
                    self.childSize = CGSize(width: 60.0, height: 60.0)
                } else {
                self.childSize = preferences
                }
            }
        
            .environmentObject(tabViewClass)
        }
        
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

struct CalendarReminderView_iPhone_Previews: PreviewProvider {
    static var previews: some View {
        CalendarReminderView_iPhone()
    }
}


struct NavigationConfigurator: UIViewControllerRepresentable {
    var configure: (UINavigationController) -> Void = { _ in }

    func makeUIViewController(context: UIViewControllerRepresentableContext<NavigationConfigurator>) -> UIViewController {
        UIViewController()
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<NavigationConfigurator>) {
        if let nc = uiViewController.navigationController {
            self.configure(nc)
        }
    }

}
