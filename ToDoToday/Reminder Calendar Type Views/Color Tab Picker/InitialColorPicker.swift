//
//  InitialColorPicker.swift
//  ToDoToday
//
//  Created by Noe De La Croix on 04/08/2021.
//

import SwiftUI

struct InitialColorPicker: View {
    
    @State private var tabColorInit = TabColor.Amethyst
    
    @State var selection: String = "none"
    
    
    @Binding var customColor: Color
    @Binding var calendarName: String
    
    @EnvironmentObject var transferColorPalette:TransferColorPalette
    
    
    var body: some View {
        

        Form {
//        LazyVGrid(columns: columns, spacing: 10) {
//
//                ForEach(TabColor.allCases, id: \.self) { colorType in
//                    ZStack {
//                        Circle().fill(Color(colorType.associatedColor))
//                            .frame(width: 25, height: 25)
//                            .onTapGesture(perform: {
//                                selection = colorType.rawValue
//                                customColor = Color(colorType.associatedColor)
//                            })
//
//                        if selection == colorType.rawValue {
//                            Image(systemName: "checkmark").frame(width: 20, height: 20).foregroundColor(Color.white)
//                        }
//                    }
//                }
            
                                ForEach(transferColorPalette.colorpla, id: \.self) { colorType in
                        
                        HStack {
                            
                            
                            
                            ZStack {
                                Circle().fill(colorType.color)
                                    .frame(width: 25, height: 25)
                                    

                                if calendarName == colorType.title {
                                    Image(systemName: "checkmark").frame(width: 20, height: 20).foregroundColor(Color.white)
                                }
                            }
                            
                            Text(colorType.title)
                            
                            
                        }.onTapGesture(perform: {
                            selection = colorType.title
                            customColor = colorType.color
                            calendarName = colorType.title
                        })
                    }
            }
    }
}

//struct InitialColorPicker_Previews: PreviewProvider {
//    static var previews: some View {
//        InitialColorPicker()
//    }
//}
