////
////  CreateNewCalendarView.swift
////  ToDoToday
////
////  Created by Noe De La Croix on 17/08/2021.
////
//
//import SwiftUI
//import LocalAuthentication
//
//struct CreateIntialCalendarView: View {
//    
//    @Environment(\.managedObjectContext) private var viewContext
//
//
//    @FetchRequest(entity: ColorPalette.entity(), sortDescriptors: []) var colorpalette: FetchedResults<ColorPalette>
//    
//    
//    @State private var newAddCalendarName: String = ""
//    @State private var newAddCalendarColor: Color = Color.red
//    @State private var newAddCalendarIsSecret: Bool = false
//    
//    @State private var toggleID: Bool = false
//    @State private var showFaceIDBioAlert: Bool = false
//    
//    
//    @State private var addedInitalCalendar: Bool = false
//    
//    
//    var body: some View {
//        
//        ZStack {
//            GeometryReader { bounds in
//                
//                VStack() {
//                    
//                    VStack {
//                        Text("Create your first calendar").font(.title).bold()
//                        Image(systemName: "calendar.badge.plus").font(.title)
//                    }.padding()
//                    if !addedInitalCalendar && colorpalette.isEmpty {
//                    VStack {
//                        Form {
//                            Section(header: Text("Calendar Name")) {
//                                TextField("Calendar Name", text: $newAddCalendarName)
//                                
//                                Toggle(isOn: $toggleID) {
//                                    Text("Enable FaceID")
//                                }.onChange(of: toggleID, perform: {newValue in
//                                    authenticate()
//                                })
//                            }.alert(isPresented: $showFaceIDBioAlert, content: {
//                                Alert(title: Text("You need to enroll some biometric for this option to work"))
//                            })
//                            
//                            Section {
//                                ColorPicker("Calendar Color", selection: $newAddCalendarColor)
//                            }
//                            
//                            Section {
//                                Button(action: {
//                                        let colorPal = ColorPalette(context: viewContext)
//                                        colorPal.id = UUID()
//                                        colorPal.name = newAddCalendarName
//                                        colorPal.paletteColor = SerializableColor.init(from: newAddCalendarColor)
//                                        colorPal.isSecret = newAddCalendarIsSecret
//                                        colorPal.isMarked = true //So that newly created calendar are automatically assigned
//                                        addedInitalCalendar = true
//                                        
//                                    
//                                        do {
//                                            try viewContext.save()
//                                        }
//                                        catch {
//                                            print(error.localizedDescription)
//                                            print("ERROR COULDNT ADD A PALETTE")
//                                        }
//                                }) {
//                                    Text("Add to new calendar")
//                                }
//                            }
//                        }
//                    }.padding()
//                    .overlay(RoundedRectangle(cornerRadius: 16)
//                                .stroke(lineWidth: 2)
//                                .foregroundColor(Color("lightFormGray"))
//                    )
//                    .frame(width: bounds.size.width * 0.9, height: bounds.size.height * 0.8)
//                }
//                    else if !colorpalette.isEmpty {
//                        Text("Looks like you already used the app before")
//                    }
//                    else {
//                    VStack {
//                        ForEach(colorpalette, id:  \.self) {palette in
//                            HStack {
//                                Circle().fill(palette.paletteColor?.color ?? .clear)
//                                Text(palette.name ??  "ERROR UNABLE TO GET NAME")
//                            }
//                        }
//                    }
//                }
//                    
//                Text("* Don't worry, you'll be able to add more calendars and edit them later on").font(.caption).foregroundColor(Color.gray)
//                    
//                    
//                }.frame(width: bounds.size.width, height: bounds.size.height, alignment: .top)
//            }
//        }
//    }
//    
//    func authenticate() {
//        let context = LAContext()
//        var error: NSError?
//
//        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
//            let reason = "Please authenticate yourself to unlock your places."
//
//            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
//
//                DispatchQueue.main.async {
//                    if success {
//                        newAddCalendarIsSecret = true
//                    } else {
//                        print("Could not auth")
//                        toggleID = false
//                    }
//                }
//            }
//        } else {
//            // no biometrics
//            toggleID = false
//            showFaceIDBioAlert = true
//        }
//    }
//}
