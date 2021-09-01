//
//  ToDoTodayApp.swift
//  ToDoToday
//
//  Created by Noe De La Croix on 21/07/2021.
//



#if targetEnvironment(macCatalyst)
    import SwiftUI
#else
    import SwiftUI
    import Firebase
    import GoogleMobileAds
#endif


@main
struct ToDoTodayApp: App {
    init() { 
        ValueTransformer.setValueTransformer(
              SerializableColorTransformer(),
              forName: NSValueTransformerName(
                rawValue: "SerializableColorTransformer"))
        
       
    }
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    let persistenceController = PersistenceController.shared
    let colorPalettePersistance = ColorPalettePersistance.shared
    var body: some Scene {
        
        WindowGroup {
            ContentView()
                //.environment(\.managedObjectContext, persistenceController.container.viewContext) // To initiliase the core data stack on the whole app, from the Content View
                
            
               
        }
    }
    
   
}

class AppDelegate:NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate{ //refers to https://stackoverflow.com/questions/30852870/displaying-a-stock-ios-notification-banner-when-your-app-is-open-and-in-the-fore
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
           
           // Set UNUserNotificationCenterDelegate
           UNUserNotificationCenter.current().delegate = self
        
        
            #if targetEnvironment(macCatalyst)
            #else
            GADMobileAds.sharedInstance().start(completionHandler: nil)
            FirebaseApp.configure()
            #endif
        
            
           
           return true
       }
}

extension AppDelegate  {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
           willPresent notification: UNNotification,
           withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        completionHandler(.alert)
    }
    
}
