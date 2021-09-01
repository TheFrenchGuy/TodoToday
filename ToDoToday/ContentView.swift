//
//  ContentView.swift
//  ToDoToday
//
//  Created by Noe De La Croix on 21/07/2021.
//

import SwiftUI
import UIKit
import PencilKit

import AppTrackingTransparency
import AdSupport



class ShowInterstitialAdClass: ObservableObject {
    @Published var InterstitialAdShow: Bool = false
}


struct ContentView: View {
    @ObservedObject var userPreference = UserPreference()
    @State var test = "Test"                                     
    @State var firstlaunch = UserDefaults.standard.value(forKey: "firstlaunch") as? Bool ?? true

    
    @StateObject var transferColorPalette = TransferColorPalette()
    @StateObject var refreshList = RefreshListClass()
    @StateObject var showInterstitialAd = ShowInterstitialAdClass()
    
    @StateObject var taskPerHour = TaskPerHour()
    
    
    let colorPalettePersistance = ColorPalettePersistance.shared
    
    
    #if !targetEnvironment(macCatalyst)
    
   
    
    private var fullScreenAd: Interstitial?
       init() {
           fullScreenAd = Interstitial()
       }
    #endif

    
    
    
    
    var body: some View {
        
        
        
        if firstlaunch {
            
            if UIDevice.current.userInterfaceIdiom == .phone {
                Text("Start it up").sheet(isPresented: self.$firstlaunch) {
                    //                if #available(iOS 15.0, *) {
                    //                    if #available(macOS 12.0, *) {
                    //                        SetupCard_Screen()
                    //                            .interactiveDismissDisabled(true)
                    //                    }
                    //
                    //                } else {
                                        SetupCard_Screen_Iphone()
                                        .modifier(DisableModalDismiss(disabled: true))
                                        
                                   // }
                                            
                                }.onAppear{
                                    
                                    print("USER TYPE \(UIDevice.current.model) ")
                                    
                                    
                                    NotificationCenter.default.addObserver(forName: NSNotification.Name("firstlaunch"), object: nil, queue: .main) { (_) in
                                            
                                        self.firstlaunch = UserDefaults.standard.value(forKey: "firstlaunch") as? Bool ?? true
                                       
                                    }
                                     
                                }
            }

            if UIDevice.current.userInterfaceIdiom == .pad || UIDevice.current.userInterfaceIdiom == .mac  {
                CalendarReminderView().edgesIgnoringSafeArea(.all).environmentObject(transferColorPalette)
                    .environment(\.managedObjectContext,colorPalettePersistance.container.viewContext)
                    .environmentObject(refreshList)
                    .environmentObject(taskPerHour)
                    .sheet(isPresented: self.$firstlaunch) {
    //                if #available(iOS 15.0, *) {
    //                    if #available(macOS 12.0, *) {
    //                        SetupCard_Screen()
    //                            .interactiveDismissDisabled(true)
    //                    }
    //
    //                } else {
                        SetupCard_Screen()
                        .modifier(DisableModalDismiss(disabled: true))
                        
                   // }
                            
                }
                
                    .onAppear{
                        NotificationCenter.default.addObserver(forName: NSNotification.Name("firstlaunch"), object: nil, queue: .main) { (_) in
                                
                            self.firstlaunch = UserDefaults.standard.value(forKey: "firstlaunch") as? Bool ?? true
                            print("\(UIDevice.current.userInterfaceIdiom) USER TYPE")
                        }
                         
                    }
            }
            
            
            
        } else {
                        
            if UIDevice.current.userInterfaceIdiom == .pad || UIDevice.current.userInterfaceIdiom == .mac{
                
                
            
                 CalendarReminderView().edgesIgnoringSafeArea(.all).environmentObject(transferColorPalette)
                .environment(\.managedObjectContext,colorPalettePersistance.container.viewContext)
                .environmentObject(refreshList)
                .environmentObject(taskPerHour)
                .environmentObject(showInterstitialAd)
                .onAppear() {requestIDFA()}
                
                
   
                .onTapGesture(perform: {
                    if self.showInterstitialAd.InterstitialAdShow {
                        
                    #if !targetEnvironment(macCatalyst)
                        self.fullScreenAd?.showAd()
                        #endif
                        self.showInterstitialAd.InterstitialAdShow = false
                    }
                })
          
                
                

            }
            if UIDevice.current.userInterfaceIdiom == .phone{
                CalendarReminderView_iPhone().edgesIgnoringSafeArea(.all).environmentObject(transferColorPalette)
                    .environment(\.managedObjectContext,colorPalettePersistance.container.viewContext)
                    .environmentObject(refreshList)
                    .environmentObject(taskPerHour)
                    .environmentObject(showInterstitialAd)
                    .onAppear() {requestIDFA()}
                
         
                    .onTapGesture(perform: {
                        if self.showInterstitialAd.InterstitialAdShow {
                            
                        #if !targetEnvironment(macCatalyst)
                            self.fullScreenAd?.showAd()
                        #endif
                            self.showInterstitialAd.InterstitialAdShow = false
                        }
                    })
           
//                    .onAppear() {sendNotification()}
//                CalendarReminderView().edgesIgnoringSafeArea(.all).environmentObject(transferColorPalette)
//                    .environment(\.managedObjectContext,colorPalettePersistance.container.viewContext)
//                    .environmentObject(refreshList)
//                    .environmentObject(taskPerHour)
            }
            //  Will need to allow to be select between the two of the options and will decide from that
            /// To put the drawing view there /// Planning rn!
//            VStack() { /// This is old and mainly used to show the image signature of the user to keep
//                Text("Well World")
//
//                if getWallpaperFromUserDefaults() != nil {
//                    Image(uiImage: UIImage(data: getWallpaperFromUserDefaults()!)! ).resizable().scaledToFit().frame(width: 100, height: 100)
//
//                }
//
//                Spacer()
//            }
        }
    }
    
//    func sendNotification() {
//        let notificationContent = UNMutableNotificationContent()
//        let userNotificationCenter = UNUserNotificationCenter.current()
//        notificationContent.title = "Test"
//        notificationContent.body = "Test body"
//        notificationContent.badge = NSNumber(value: 3)
//
//        if let url = Bundle.main.url(forResource: "dune",
//                                    withExtension: "png") {
//            if let attachment = try? UNNotificationAttachment(identifier: "dune",
//                                                            url: url,
//                                                            options: nil) {
//                notificationContent.attachments = [attachment]
//            }
//        }
//
//
//
//
//
//
//
//
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5,
//                                                        repeats: false)
//
//
//        let request = UNNotificationRequest(identifier: "testNotification",
//                                            content: notificationContent,
//                                            trigger: trigger)
//
//        userNotificationCenter.add(request) { (error) in
//            if let error = error {
//                print("Notification Error: ", error)
//            }
//        }
//
//
//
//
//
//
//    }
    
    
    
    func getWallpaperFromUserDefaults() -> Data? {
      let defaults = UserDefaults.standard
        return defaults.object(forKey: "signatureImage") as? Data
    }
    
    func requestIDFA() {
      ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
        // Tracking authorization completed. Start loading ads here.
        // loadAd()
      })
    }
    
    func scheduleNotification() {
        print("test") //MARK: YET TO IMPLEMENT WHEN NOTIFICATIONS WILL BE DISPLAYED ON SCREEN 
//        let hours = Calendar.current.component(.hour, from: date)
//        let minutes = Calendar.current.component(.minute, from: date)
//
//        userPreference.notificationTime.hour = hours
//        userPreference.notificationTime.minute = minutes
//
//        //print(test)
//
//        //userPreference.notificationTime = test
//
//        print(userPreference.notificationTime)
    }
}

//Image(uiImage: UserDefaults.standard.object(forKey: "signatureImage") as! UIImage).resizable().scaledToFit()

 

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
 /// This is to disable the swipe down whent the setup of the app has not yet been complited, much easier in IOS 15











