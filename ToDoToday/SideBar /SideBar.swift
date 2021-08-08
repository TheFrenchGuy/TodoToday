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
        GeometryReader { bounds in
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
            
                VStack(alignment: .leading) {
                   
                    Text("Calendars").font(.largeTitle).bold().padding(.leading, 10)

                    VStack {
                        Form  {
                            ForEach(colorpalette, id: \.self) { palette in

                                CheckboxField(id: palette.id!.uuidString, label: palette.name!,color: palette.paletteColor!.color, callback: checkboxSelected).contextMenu {
                                    Button(action: {viewContext.delete(palette)
                                        do {
                                            try self.viewContext.save()
                                            print("Calendar successfully deleted")
                                        } catch {
                                            print(error)
                                        }
                                    }) {
                                        Text("Delete me")
                                    }
                                }
                            }.fixedSize(horizontal: true, vertical: true)
                            
                            

                        }.frame(height: bounds.size.height * 0.8)
                        
                        
                    }
                    
                  
                    
                    
                    
                    Divider()
                    
                    HStack {
                        
                        Spacer()
                        
                        Button(action: {
                                addNewPalette.toggle()
                                
                                
                            }) {
                                HStack {
                                    Text("New Calendar")
                                    Image(systemName: "plus")
                                }
                            }
                    }
                    
                    Spacer()
                }.frame(width: bounds.size.width,height: bounds.size.height, alignment: .leading)
                
                
               
                    
                    
        
                    
                  
                    
                    
                
                    
//                VStack() {
//
//                    Text("Calendars 123").font(.largeTitle).bold()
//
//                    Spacer().opacity(0.0)
//
//                    Button(action: {
//        //                let colorPal = ColorPalette(context: viewContext)
//        //                colorPal.id = UUID()
//        //                colorPal.name = "Test Color Pal"
//                        addNewPalette.toggle()
//
//
//                    }) {
//                        HStack {
//                            Text("New Calendar")
//                            Image(systemName: "plus")
//                        }
//                    }
//
//                }.frame(width: bounds.size.width,height: bounds.size.height, alignment: .leading)
//                .padding(.top, 20)
//                .padding(.leading, 10)
//                .zIndex(1)
//
                    
                    
                   
                    
               
                
                
                
                    
                }
            }.frame(height: bounds.size.height)
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

