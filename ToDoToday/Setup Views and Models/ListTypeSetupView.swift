//
//  ListTypeSetupView.swift
//  ToDoToday
//
//  Created by Noe De La Croix on 21/07/2021.
//

import SwiftUI
import UIKit
import Introspect
struct ListTypeSetupView: View {
    
    @State private var showcheck1 = false
    @State private var showcheck2 = false
    @State private var completed = false
    @State private var storeInICLOUD = true
    @ObservedObject var userPreference = UserPreference()
    
    let colorPalettePersistance = ColorPalettePersistance.shared
    let notificationPersistance = NotificationDayPersistence.shared
    
    
    var body: some View {
        if !completed {
        TabView() {
            
                
            CreateIntialCalendarView().environment(\.managedObjectContext, colorPalettePersistance.container.viewContext)
            
            NotificationPermessionView().environment(\.managedObjectContext, notificationPersistance.container.viewContext)
            
            
            
            iCloudSyncView(enableiCloudSync: $storeInICLOUD)
            
            TermsandConditionView()
            
            SignandCompleteView(completion: $completed, storeInIC: $storeInICLOUD).environment(\.managedObjectContext, colorPalettePersistance.container.viewContext)
            
            
        
            
            
        }
        
        .introspectViewController { viewController in
                    // Get called
                    // viewController is PresentationHostingController
                    // viewController.view is UIHostingView
                    if let collectionView = viewController.view.find(for: UICollectionView.self) {
                        collectionView.alwaysBounceVertical = false
                    }
                }
        .tabViewStyle(PageTabViewStyle()) //Page scrolling view
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always)) //Show the number of tabs there is
        } else {
            CompletionView(storeInIC: $storeInICLOUD)
        }
    }
}

//2
//struct ListTypeSetupView_Previews: PreviewProvider {
//    static var previews: some View {
//        if #available(iOS 15.0, *) {
//            ListTypeSetupView()
//                .previewInterfaceOrientation(.landscapeLeft)
//        } else {
//            // Fallback on earlier versions
//        }
//    }
//}


extension UIView {
    func find<T: UIView>(for type: T.Type, maxLevel: Int = 3) -> T? {
        guard maxLevel >= 0 else {
            return nil
        }

        if let view = self as? T {
            return view
        } else {
            for view in subviews {
                if let found = view.find(for: type, maxLevel: maxLevel - 1) {
                    return found
                }
            }
        }

        return nil
    }
}
