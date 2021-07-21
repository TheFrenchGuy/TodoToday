//
//  ContentView.swift
//  ToDoToday
//
//  Created by Noe De La Croix on 21/07/2021.
//

import SwiftUI
import UIKit
import PencilKit

struct ContentView: View {
    @ObservedObject var userPreference = UserPreference()
    @State var test = "Test"
    @State var firstlaunch = UserDefaults.standard.value(forKey: "firstlaunch") as? Bool ?? true
    
    
    var body: some View {
        if firstlaunch {
            Text ("Start it up")
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
                }
                
            }
        } else {
            CalendarReminderView() //  Will need to allow to be select between the two of the options and will decide from that
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
    
    func getWallpaperFromUserDefaults() -> Data? {
      let defaults = UserDefaults.standard
        return defaults.object(forKey: "signatureImage") as? Data
    }
    
    func scheduleNotification() {
        print("test")
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











