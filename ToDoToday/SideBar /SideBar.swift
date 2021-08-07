//
//  SideBar.swift
//  ToDoToday
//
//  Created by Noe De La Croix on 06/08/2021.
//

import SwiftUI
import LocalAuthentication

struct SideBarView: View {
    
        @Environment(\.managedObjectContext) private var viewContext
    
    
        @FetchRequest(entity: ColorPalette.entity(), sortDescriptors: []) var colorpalette: FetchedResults<ColorPalette>
    
        @State private var addNewPalette: Bool = false
    
    @State private var newAddCalendarName: String = ""
    @State private var newAddCalendarColor: Color = Color.red
    @State private var newAddCalendarIsSecret: Bool = false
    
    @State private var toggleID: Bool = false
    
    
    var body: some View {
        ZStack {
        if addNewPalette {
            VStack {
                Form {
                    Section(header: Text("Calendar Name")) {
                        TextField("Calendar Name", text: $newAddCalendarName)
                        
                        Toggle(isOn: $toggleID) {
                            Text("Enable FaceID")
                        }.onChange(of: toggleID, perform: {newValue in
                            authenticate()
                        })
                    }
                    
                    Section {
                        ColorPicker("Calendar Color", selection: $newAddCalendarColor)
                    }
                    
                    Section {
                        Button(action: {
                                let colorPal = ColorPalette(context: viewContext)
                                colorPal.id = UUID()
                                colorPal.name = newAddCalendarName
                                colorPal.paletteColor = SerializableColor.init(from: newAddCalendarColor)
                                colorPal.isSecret = newAddCalendarIsSecret
                                addNewPalette.toggle()
                            
                                do {
                                    try viewContext.save()
                                }
                                catch {
                                    print(error.localizedDescription)
                                    print("ERROR COULDNT ADD A PALETTE")
                                }
                        }) {
                            Text("Add to new calendar")
                        }
                    }
                }
            }
        } else {
        
            VStack{
                ForEach(colorpalette, id: \.self) { palette in
                   
                    CheckboxField(id: palette.id!.uuidString, label: palette.name!,callback: checkboxSelected)
                }
                
                Button(action: {
    //                let colorPal = ColorPalette(context: viewContext)
    //                colorPal.id = UUID()
    //                colorPal.name = "Test Color Pal"
                    addNewPalette.toggle()
                    
                    
                }) {
                    HStack {
                        Text("New Calendar")
                        Image(systemName: "plus")
                    }
                }
            }
            }
        }
          
            
//        List {
//            CheckboxField(id: "Calendar1", label: "Calendar1", callback: checkboxSelected)
//            CheckboxField(id: "Calendar2", label: "Calendar2", callback: checkboxSelected)
//            CheckboxField(id: "Calendar3", label: "Calendar3", callback: checkboxSelected)
//            CheckboxField(id: "Calendar4", label: "Calendar4", callback: checkboxSelected)
//        }
    }
        
    
    func checkboxSelected(id: String, isMarked: Bool) {
            print("\(id) is marked: \(isMarked)")
        }
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Please authenticate yourself to unlock your places."

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in

                DispatchQueue.main.async {
                    if success {
                        newAddCalendarIsSecret = true
                    } else {
                        print("Could not auth")
                        toggleID = false
                    }
                }
            }
        } else {
            // no biometrics
            toggleID = false
        }
    }
}

//struct SideBar_Previews: PreviewProvider {
//    static var previews: some View {
//        SideBarView()
//    }
//}


struct CheckboxField: View {
    let id: String
    let label: String
    let size: CGFloat
    let color: Color
    let textSize: Int
    let callback: (String, Bool)->()
    
    init(
        id: String,
        label:String,
        size: CGFloat = 10,
        color: Color = Color.black,
        textSize: Int = 14,
        callback: @escaping (String, Bool)->()
        ) {
        self.id = id
        self.label = label
        self.size = size
        self.color = color
        self.textSize = textSize
        self.callback = callback
    }
    
    @State var isMarked:Bool = false
    
    var body: some View {
        Button(action:{
            self.isMarked.toggle()
            self.callback(self.id, self.isMarked)
        }) {
            HStack(alignment: .center, spacing: 10) {
                Image(systemName: self.isMarked ? "checkmark.square" : "square")
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: self.size, height: self.size)
                Text(label)
                    .font(Font.system(size: size))
                Spacer()
            }.foregroundColor(self.color)
        }
        .foregroundColor(Color.white)
    }
}
