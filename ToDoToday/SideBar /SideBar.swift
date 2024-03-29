//
//  SideBar.swift
//  ToDoToday
//
//  Created by Noe De La Croix on 06/08/2021.
//

import SwiftUI
import LocalAuthentication


class RefreshListClass: ObservableObject {
    @Published var refresh: Bool = false
}

struct SideBarView: View {
    
        @Environment(\.managedObjectContext) private var viewContext
    
    
        @FetchRequest(entity: ColorPalette.entity(), sortDescriptors: []) var colorpalette: FetchedResults<ColorPalette>
    
        @State private var addNewPalette: Bool = false
    
    @State private var newAddCalendarName: String = ""
    @State private var newAddCalendarColor: Color = Color.red
    @State private var newAddCalendarIsSecret: Bool = false
    
    @State private var toggleID: Bool = false
    @State private var showFaceIDBioAlert: Bool = false
    
//    @StateObject var transferColorPalette = TransferColorPalette()
    @EnvironmentObject var transferColorPalette:TransferColorPalette
    
    @EnvironmentObject var refreshListClass:RefreshListClass
    
    
    @State private var isEmptyCalendarAlert: Bool = false
    
    var body: some View {
        GeometryReader { bounds in
            ZStack {
               
            if addNewPalette {
                VStack {
                    
                    Button(action: {addNewPalette.toggle()}) {
                        HStack {
                            Image(systemName: "chevron.left").font(.headline)
                            Text("Calendar").font(.headline)
                        }.padding()
                    }.frame(width: bounds.size.width, alignment: .leading)
                    Form {
                        Section(header: Text("Calendar Name")) {
                            TextField("Calendar Name", text: $newAddCalendarName).frame(width: bounds.size.width)
                            
                            Toggle(isOn: $toggleID) {
                                Text("Enable FaceID")
                            }.onChange(of: toggleID, perform: {newValue in
                                authenticate()
                            })
                        }.alert(isPresented: $showFaceIDBioAlert, content: {
                            Alert(title: Text("You need to enroll some biometric for this option to work"))
                        })
                        
                        Section {
                            ColorPicker("Calendar Color", selection: $newAddCalendarColor)
                        }
                        
                        Section {
                            Button(action: {
                                
                                if !newAddCalendarName.isEmpty {
                                    let colorPal = ColorPalette(context: viewContext)
                                    colorPal.id = UUID()
                                    colorPal.name = newAddCalendarName
                                    colorPal.paletteColor = SerializableColor.init(from: newAddCalendarColor)
                                    colorPal.isSecret = newAddCalendarIsSecret
                                    colorPal.isMarked = true //So that newly created calendar are automatically assigned
                                    addNewPalette.toggle()
                                
                                    do {
                                        try viewContext.save()
                                    }
                                    catch {
                                        print(error.localizedDescription)
                                        print("ERROR COULDNT ADD A PALETTE")
                                    }
                                } else {
                                    isEmptyCalendarAlert = true
                                }
                                
                            }) {
                                Text("Add to new calendar")
                            }.alert(isPresented: $isEmptyCalendarAlert) {
                                Alert(title: Text("Empty Calendar"),
                                      message: Text("Well obviously you cant add an empty calendar🙄"))
                            }
                        }
                    }
                }.frame(width: bounds.size.width, height: bounds.size.height)
            } else {
            
                VStack(alignment: .leading) {
                   
                    Text("Calendars").font(.largeTitle).bold().padding(.leading, 10)

                    VStack {
                        Form  {
                            ForEach(colorpalette, id: \.self) { palette in

                                CheckboxField(id: palette.id!.uuidString, label: palette.name!,color: palette.paletteColor!.color, callback: checkboxSelected, isSecure: palette.isSecret).contextMenu {
                                    Button(action: {
                                        viewContext.delete(palette)
                                        loadInitialColorPalette()
                                        do {
                                            try self.viewContext.save()
                                            print("Calendar successfully deleted")
                                        } catch {
                                            print(error)
                                            print("ERROR THERE")
                                        }
                                    }) {
                                        Text("Delete me")
                                    }
                                }
                            }.fixedSize(horizontal: true, vertical: true)
                            
                            

                        }.frame(height: bounds.size.height * 0.8)
                        
//                        ForEach(transferColorPalette.colorpla, id: \.self) {colorType in
//                            Text("hey")
//                        }
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
                    .onAppear(perform: {
                      loadInitialColorPalette()
                    })
                
                
               
                    
                    
        
                    
                  
                    
                    
                
                    
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
            }.frame(width: bounds.size.width ,height: bounds.size.height)
             
        }
          
    }
        
    
    func checkboxSelected(id: String, isMarked: Bool) {
            print("\(id) is marked: \(isMarked)")
        
        for color in colorpalette {
            if id == color.id?.uuidString && isMarked{
                color.isMarked = true
                do {
                    try viewContext.save()
                } catch {
                    print(error.localizedDescription)
                }
                print("Is marked")
            } else if id == color.id?.uuidString && !isMarked {
                color.isMarked = false
                do {
                    try viewContext.save()
                } catch {
                    print(error.localizedDescription)
                }
                print("Is NOT marked")
            }
        }
        

        loadInitialColorPalette()
//
//        //refreshList.toggle()
        refreshListClass.refresh.toggle()
            
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
            showFaceIDBioAlert = true
        }
    }
    
    func loadInitialColorPalette() {
        transferColorPalette.colorpla.removeAll()
       // transferColorPalette.colorpla.title.removeAll()
        
        
        for color in colorpalette {
//            transferColorPalette.title.append(color.name!)
//            transferColorPalette.color.append(color.paletteColor!.color)
            
            transferColorPalette.colorpla.append(ColorPaletteTemp(id: color.id!, title: color.name!, color: color.paletteColor!.color,isMarked: color.isMarked))
        }
        
        print("Assigned variables")
    }
}

//struct SideBar_Previews: PreviewProvider {
//    static var previews: some View {
//        SideBarView()
//    }
//}

