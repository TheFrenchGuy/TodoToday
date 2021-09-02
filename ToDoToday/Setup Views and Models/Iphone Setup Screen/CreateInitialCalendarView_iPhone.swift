//
//  CreateInitialCalendarView_iPhone.swift
//  CreateInitialCalendarView_iPhone
//
//  Created by Noe De La Croix on 30/08/2021.
//


import SwiftUI
import LocalAuthentication

struct CreateIntialCalendarView: View {
    
    @Environment(\.managedObjectContext) private var viewContext


    @FetchRequest(entity: ColorPalette.entity(), sortDescriptors: []) var colorpalette: FetchedResults<ColorPalette>
    
    
    @State private var newAddCalendarName: String = ""
    @State private var newAddCalendarColor: Color = Color.red
    @State private var newAddCalendarIsSecret: Bool = false
    
    @State private var toggleID: Bool = false
    @State private var showFaceIDBioAlert: Bool = false
    
    
    @State private var addedInitalCalendar: Bool = false
    
    @State private var showAlertEmptyTitle: Bool = false
    
    
    var body: some View {
        
        ZStack {
            GeometryReader { bounds in
                
                VStack() {
                    
                    VStack {
                        Text("Create your first calendar").font(.title).bold()
                        Image(systemName: "calendar.badge.plus").font(.title)
                    }.padding()
                     .padding(.top, 70)
                    if !addedInitalCalendar && colorpalette.isEmpty {
                    VStack {
                        
                            VStack(alignment: .leading) {
                                
                                HStack {
                                    Text("Calendar Name")
                                    Image(systemName: "a.magnify")
                                    Text(":")
                                }
                                
                                TextField("Calendar Name", text: $newAddCalendarName).padding(.leading, 10)
                                
                                
                            }.frame(width: bounds.size.width * 0.8)
                            .padding()
                           .background(RoundedRectangle(cornerRadius: 15).opacity(0.15)
                                           .shadow(color: .black.opacity(0.5), radius: 15, x: 10, y: 10))
                           .padding(.bottom, 40)
                        
                            VStack {
                                Toggle(isOn: $toggleID) {
                                    Text("Enable FaceID")
                                    Image(systemName: "faceid")
                                }.onChange(of: toggleID, perform: {newValue in
                                    authenticate()
                                })
                            }.alert(isPresented: $showFaceIDBioAlert, content: {
                                Alert(title: Text("You need to enroll some biometric for this option to work"))
                            }).frame(width: bounds.size.width * 0.8)
                            .padding()
                           .background(RoundedRectangle(cornerRadius: 15).opacity(0.15)
                                           .shadow(color: .black.opacity(0.5), radius: 15, x: 10, y: 10))
                           .padding(.bottom, 40)
                            
                            VStack {
                                ColorPicker("Calendar Color", selection: $newAddCalendarColor)
                            }.frame(width: bounds.size.width * 0.8)
                            .padding()
                           .background(RoundedRectangle(cornerRadius: 15).opacity(0.15)
                                           .shadow(color: .black.opacity(0.5), radius: 15, x: 10, y: 10))
                           .padding(.bottom, 40)
                            
                            VStack {
                                Button(action: {
                                    
                                    
                                    if newAddCalendarName != "" {
                                    
                                        let colorPal = ColorPalette(context: viewContext)
                                        colorPal.id = UUID()
                                        colorPal.name = newAddCalendarName
                                        colorPal.paletteColor = SerializableColor.init(from: newAddCalendarColor)
                                        colorPal.isSecret = newAddCalendarIsSecret
                                        colorPal.isMarked = true //So that newly created calendar are automatically assigned
                                        addedInitalCalendar = true
                                        
                                    
                                        do {
                                            try viewContext.save()
                                        }
                                        catch {
                                            print(error.localizedDescription)
                                            print("ERROR COULDNT ADD A PALETTE")
                                        }
                                    } else {
                                        showAlertEmptyTitle = true
                                    }
                                }) {
                                    
                                    HStack {
                                        Text("Add your first Calendar")
                                        Image(systemName: "plus")
                                    }
                                }.alert(isPresented: $showAlertEmptyTitle) {
                                    Alert(title: Text("Empty Calendar"),
                                          message: Text("Well obviously you cant add an empty calendar🙄"))
                                }
                            
                        }.frame(width: bounds.size.width * 0.8)
                            .padding()
                           .background(RoundedRectangle(cornerRadius: 15).opacity(0.15)
                                           .shadow(color: .black.opacity(0.5), radius: 15, x: 10, y: 10))
                           .padding(.bottom, 40)
                    }.padding()
                    
                }
                    else if !colorpalette.isEmpty && !addedInitalCalendar{
                        
                        VStack {
                            
                            
                            
                            VStack {
                                
                            Text("🤩 Looks like you already used the app before").bold().padding()
                            }.frame(width: bounds.size.width * 0.8)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 15)
                                                .shadow(color: .black.opacity(0.5), radius: 15, x: 10, y: 10).foregroundColor(Color.green))
                               .padding(.bottom, 40)

                        
                        
                            Text("Here are what calendars we have from you").font(.subheadline).padding(.bottom, 30)
                            
                            
                            VStack {
                                
                                ScrollView {
                                    ForEach(colorpalette, id:  \.self) {palette in
                                        HStack {
                                            RoundedRectangle(cornerRadius: 12).fill(palette.paletteColor?.color ?? .clear)
                                            Text(palette.name ??  "ERROR UNABLE TO GET NAME")
                                        }
                                    }
                                    
                                }
                            }.frame(width: bounds.size.width * 0.8, height: bounds.size.height * 0.3)
                                .padding()
                               .background(RoundedRectangle(cornerRadius: 15).opacity(0.15)
                                               .shadow(color: .black.opacity(0.5), radius: 15, x: 10, y: 10))
                               .padding(.bottom, 20)

                                
                            
                        
                        }
                        
                    }
                    else {
                    VStack {
                        
                        Text("Here is your first Calendar:").font(.headline)
                        
                        
                        ForEach(colorpalette, id:  \.self) {palette in
                            VStack {
                                Circle().fill(palette.paletteColor?.color ?? .clear).frame(width: 24, height: 24)
                                Text(palette.name ??  "ERROR UNABLE TO GET NAME")
                            }
                        }
                    }.frame(width: bounds.size.width * 0.9, height: bounds.size.height * 0.7)
                }
                    
                Text("* Don't worry, you'll be able to add more calendars and edit them later on").font(.caption).foregroundColor(Color.gray)
                    
                Spacer()
                
                    
                    
                }.frame(width: bounds.size.width, height: bounds.size.height, alignment: .center)
            }
        }
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
}
