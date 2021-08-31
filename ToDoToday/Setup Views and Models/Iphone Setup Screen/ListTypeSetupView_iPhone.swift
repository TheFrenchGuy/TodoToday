//
//  ListTypeSetupView_iPhone.swift
//  ListTypeSetupView_iPhone
//
//  Created by Noe De La Croix on 30/08/2021.
//

import SwiftUI

struct ListTypeSetupView_iPhone: View {
    @State private var showcheck1 = false
    @State private var showcheck2 = false
    @State private var completed = false
    @State private var storeInICLOUD = true
    @ObservedObject var userPreference = UserPreference()
    
    let colorPalettePersistance = ColorPalettePersistance.shared
    
    
    var body: some View {
        if !completed {
        TabView() {
            
                
            CreateIntialCalendarView().environment(\.managedObjectContext, colorPalettePersistance.container.viewContext)
            
            NotificationPermessionView()
            
            
            
            iCloudSyncView(enableiCloudSync: $storeInICLOUD)
            
            TermsandConditionView()
            
            SignandCompleteView(completion: $completed, storeInIC: $storeInICLOUD).environment(\.managedObjectContext, colorPalettePersistance.container.viewContext)
            
            
        
            
            
        }.tabViewStyle(PageTabViewStyle()) //Page scrolling view
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always)) //Show the number of tabs there is
        } else {
            CompletionView(storeInIC: $storeInICLOUD)
        }
    }
}

struct ListTypeSetupView_iPhone_Previews: PreviewProvider {
    static var previews: some View {
        ListTypeSetupView_iPhone()
    }
}
