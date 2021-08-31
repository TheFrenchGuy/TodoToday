//
//  ToDoTodayApp.swift
//  ToDoToday
//
//  Created by Noe De La Croix on 21/07/2021.
//

import SwiftUI

@main
struct ToDoTodayApp: App {
    init() { 
        ValueTransformer.setValueTransformer(
              SerializableColorTransformer(),
              forName: NSValueTransformerName(
                rawValue: "SerializableColorTransformer"))
        
       
    }
    
    
    let persistenceController = PersistenceController.shared
    let colorPalettePersistance = ColorPalettePersistance.shared
    var body: some Scene {
        
        WindowGroup {
            ContentView()
                //.environment(\.managedObjectContext, persistenceController.container.viewContext) // To initiliase the core data stack on the whole app, from the Content View
                
            
               
        }
    }
}
