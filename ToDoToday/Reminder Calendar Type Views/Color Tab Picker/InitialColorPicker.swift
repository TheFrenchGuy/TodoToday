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
    
    @EnvironmentObject var transferColorPalette:TransferColorPalette
    
    
    var body: some View {
        
        let columns = [
                    GridItem(.adaptive(minimum: 30))
                ]

        HStack {
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
            
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(transferColorPalette.colorpla, id: \.self) { colorType in
                    ZStack {
                        Circle().fill(colorType.color)
                            .frame(width: 25, height: 25)
                            .onTapGesture(perform: {
                                selection = colorType.title
                                customColor = colorType.color
                            })

                        if selection == colorType.title {
                            Image(systemName: "checkmark").frame(width: 20, height: 20).foregroundColor(Color.white)
                        }
                    }
                }
            }
        
            ColorPicker(selection: $customColor, label: {EmptyView()})
            }
    }
}

//struct InitialColorPicker_Previews: PreviewProvider {
//    static var previews: some View {
//        InitialColorPicker()
//    }
//}
