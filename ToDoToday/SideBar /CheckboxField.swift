//
//  CheckboxField.swift
//  ToDoToday
//
//  Created by Noe De La Croix on 07/08/2021.
//

import SwiftUI
import LocalAuthentication

struct CheckboxField: View {
    
    
        @Environment(\.managedObjectContext) private var viewContext
    
    
        @FetchRequest(entity: ColorPalette.entity(), sortDescriptors: []) var colorpalette: FetchedResults<ColorPalette>
    
    
    @EnvironmentObject var refreshListClass:RefreshListClass
    @EnvironmentObject var transferColorPalette:TransferColorPalette
    
    let id: String
    let label: String
    let size: CGFloat
    let color: Color
    let textSize: Int
    let isSecure: Bool
    let callback: (String, Bool)->()
    
    init(
        id: String,
        label:String,
        size: CGFloat = 30,
        color: Color = Color.black,
        textSize: Int = 22,
        callback: @escaping (String, Bool)->(),
        isSecure: Bool = false
        ) {
        self.id = id
        self.label = label
        self.size = size
        self.color = color
        self.textSize = textSize
        self.callback = callback
        self.isSecure = isSecure
    }
    
    @State var isMarked:Bool = false
    
    var body: some View {
        Button(action:{
            if isSecure {
                authenticate()
                self.isMarked.toggle()
               
            } else {
                self.isMarked.toggle()
                
            }
            self.callback(self.id, self.isMarked)
        }) {
            HStack(alignment: .center, spacing: 10) {
                if self.isMarked {
                    
                    ZStack {
                        
                        Circle().foregroundColor(self.color).frame(width: self.size, height: self.size)
                        
                        Image(systemName: "checkmark")
                          //  .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(Color.white)
                            .frame(width: self.size - 15, height: self.size - 15)
                        
                        
                    }
                } else {
                    Circle().foregroundColor(self.color).frame(width: self.size, height: self.size)
                }
                
                Text(label)
                    .font(Font.system(size: size))
                Spacer()
            }.onAppear(perform: {isPreMarked()})
        }.foregroundColor(Color.black)
        
    }
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Please authenticate yourself to unlock your places."

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in

                DispatchQueue.main.async {
                    if success {
                        isMarked = true
                    } else {
                        print("Could not auth")
                        isMarked = false
                    }
                }
            }
        } else {
            // no biometrics
            isMarked = false
        }
    }
    
    func isPreMarked() {
        for color in colorpalette {
            if color.id?.uuidString == id {
                if color.isMarked {
                    isMarked = true
                    
                }
            }
        }
    }
    
}


//struct CheckboxField_Previews: PreviewProvider {
//    static var previews: some View {
//        CheckboxField()
//    }
//}
