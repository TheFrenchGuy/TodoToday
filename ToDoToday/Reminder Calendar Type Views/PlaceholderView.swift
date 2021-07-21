//
//  PlaceholderView.swift
//  ToDoToday
//
//  Created by Noe De La Croix on 21/07/2021.
//

import SwiftUI

struct PlaceholderView : View { // View that acts there when there is no drawings on the screen to initiate user input
    var body: some View {
        VStack(spacing: 20) {
            Text("Let's draw something")
                .font(.largeTitle)
            
            Text("Select or create new drawing from left menu")
            
            Image(systemName: "scribble")
                .font(.largeTitle)
            
        }.foregroundColor(.gray)
        
    }
}
