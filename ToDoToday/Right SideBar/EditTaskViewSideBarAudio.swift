//
//  EditTaskViewSideBarAudio.swift
//  EditTaskViewSideBarAudio
//
//  Created by Noe De La Croix on 31/08/2021.
//

import SwiftUI

struct EditTaskViewSideBarAudio: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(entity: DrawingCanvas.entity(), sortDescriptors: []) var drawings: FetchedResults<DrawingCanvas>
    @EnvironmentObject var tabViewClass: TabViewClass
    
    let fileManager = FileManager.default
    let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    
    @EnvironmentObject var transferColorPalette:TransferColorPalette
    
    
    @State private var updatedTask = updatedTaskDesClass()
    
    
    @State private var editTask: Bool = false
    
    @State private var newTaskTitle: String = ""
    @State private var newStartTime: Date = Date()
    @State private var newEndTime: Date = Date().addingTimeInterval(3600)
    @State private var newColor: Color = Color.green
    @State private var newCalendarName: String = "none"
    @State private var action: String = "Normal" // View should have state either of normal, alert or calendar
    
    
    @ObservedObject var audioPlayer = AudioPlayer()
    
    
    
    @State var alertTimes = [
        AlertNotificationTimes(nameDesc: "At time of event", timeofNotification: 0),
        AlertNotificationTimes(nameDesc: "5 minutes before", timeofNotification: 300),
        AlertNotificationTimes(nameDesc: "10 minutes before", timeofNotification: 600),
        AlertNotificationTimes(nameDesc: "15 minutes before", timeofNotification: 900),
        AlertNotificationTimes(nameDesc: "30 minutes before", timeofNotification: 1800),
        AlertNotificationTimes(nameDesc: "1 hour before", timeofNotification: 3600),
        AlertNotificationTimes(nameDesc: "2 hours before", timeofNotification: 7200),
        
    ]
    
    
    @State var alertTimeSelected: String = ""
    
    
    var body: some View {
        
        ZStack {
            HStack {
                
                Divider()
                
                GeometryReader { bounds in
                    ForEach(drawings, id: \.self) {drawing in
                       
                            if drawing.id == tabViewClass.editTaskUUID {
                                ZStack {
                                if self.action == "Normal" {
                                    VStack(alignment: .leading) {
                                        
                                        HStack {
                                            
                                            if editTask {
                                                TextField("Title", text: $newTaskTitle)
                                            } else {
                                                Text(drawing.title ?? "No title").font(.title).bold()
                                            }
                                            Spacer()
                                            Button(action: {
                                                //MARK: So that you can edit the text
                                                editTask.toggle()
                                                
                                                if editTask {
//                                                newTaskTitle = drawing.title ?? "NO TITLE"
//                                                newStartTime = drawing.startTime ?? Date()
//                                                newEndTime = drawing.endTime ?? Date().addingTimeInterval(3600)
//                                                newTaskDescription = drawing.taskDescription ?? "NO TASK DESC"
                                                } else {
                                                    updateField(canvasUUID: drawing.id ?? UUID())
                                                }
                                            }) {
                                                if editTask {
                                                Text("Done").foregroundColor(.red)
                                                } else { Text("Edit").foregroundColor(.red)}
                                            }
                                        }.padding()
                                        
                                        
                                        
                                        HStack {
                    
                                            Text("\(drawing.startTime?.toString(dateFormat: "EEEE, MMM d") ?? "NO VALUE")")
                                            
                                            
                                            Spacer()
                                            
                                            
                                            if editTask {
                                                DatePicker("", selection: $newStartTime, displayedComponents: .hourAndMinute)
                                                Text("to")
                                                DatePicker("", selection: $newEndTime, displayedComponents: .hourAndMinute)
                                                
                                            } else {
                                                Text("\(drawing.startTime?.toString(dateFormat: "HH:mm") ?? "NO VALUE")")
                                                Text("to")
                                                Text("\(drawing.endTime?.toString(dateFormat: "HH:mm") ?? "NO VALUE")")
                                            }
                                        }.padding()
                                            .font(.callout)
                                            .opacity(0.5)
                                        
                                        Divider()
                                        
                                        
                                        
                                        VStack(alignment: .leading) {
                                            
                                            
                                                Text("Task Description:").font(.footnote).opacity(0.5).padding(.horizontal)
                                                
                                            
                                            VStack {
                                            
                                                if audioPlayer.isPlaying == false {
                                                    Button(action: {
                                                        self.audioPlayer.startPlayback(audio: drawing.audioREMurl ?? "NO URL")
                                                    }) {
                                                        Image(systemName: "play.circle")   .resizable()
                                                            .scaledToFit()
                                                            
                                                    }.padding(.horizontal)
                                                        .frame(width: 100, height: 100)
                                                } else {
                                                    Button(action: {
                                                        self.audioPlayer.stopPlayback()
                                                    }) {
                                                        Image(systemName: "stop.fill")
                                                            .resizable()
                                                            .scaledToFit()
                                                    }.padding(.horizontal)
                                                        .frame(width: 100, height: 100)
                                                }
                                            }.frame(width: bounds.size.width * 0.95, alignment: .center)
                                            
                                            
                                            
                                        }
                                        
                                        Divider()
                                        
                                        
                                        CalendarAlertButtonView(alertMove: $action, alertTime: alertTimeSelected)
                                        
                                        CalendarEditButtonView(calendarNameAdded: $newCalendarName, tabColor: $newColor, calendarMove: $action)
                                    
                                        
                                        
                                        
                                        Spacer()
                                        
                                        
                                        Divider()
                                        
                                        HStack {
                                            Button(action: {
                                                //MARK: To save the changes
                                                newTaskTitle = drawing.title ?? "NO TITLE"
                                                newStartTime = drawing.startTime ?? Date()
                                                newEndTime = drawing.endTime ?? Date().addingTimeInterval(3600)
                                                
                                                
                                                updateField(canvasUUID: drawing.id)
                                            }) {
                                                Text("Save Changes").foregroundColor(.red)
                                            }
                                            
                                            
                                            Spacer()
                                            Button(action: {
                                                // MARK: To delete the event
                                                viewContext.delete(drawing)
                                                deleteAudio(audioURL: drawing.audioREMurl ?? "NO URL")
                                                
                                                do {
                                                    try self.viewContext.save()
                                                    tabViewClass.editTask = false
                                                } catch { print(error)}
                                            }) {
                                                Text("Delete Event").foregroundColor(.red)
                                            }
                                        }.padding()
                                            

                                    }.frame(width: bounds.size.width, height: bounds.size.height * 0.95, alignment: .topLeading)
                                }
                                
                                if self.action == "Calendar" {
                                    VStack(alignment: .leading) {
                                        
                                        Button(action: {
                                            self.action = "Normal"
                                        }) {
                                            HStack {
                                                Image(systemName: "chevron.left").font(.body)
                                                Text("Back").font(.body)
                                            }
                                        }.padding()
                                        
                                        InitialColorPicker(customColor: $newColor, calendarName: $newCalendarName)
                                    }.frame(width: bounds.size.width, height: bounds.size.height * 0.95, alignment: .topLeading)
                                        .background(Color("lightFormGray").edgesIgnoringSafeArea(.all).frame(width: bounds.size.width + 5,height: bounds.size.height))
                                        
                                }
                                    
                                    
                                if self.action  == "Notification" {
                                    VStack(alignment: .leading) {
                                        
                                        Button(action: {
                                            self.action = "Normal"
                                        }) {
                                            HStack {
                                                Image(systemName: "chevron.left").font(.body)
                                                Text("Back").font(.body)
                                            }
                                        }.padding()
                                        List(alertTimes, id: \.id) {alertTime in
                                            
                                            Button(action: {
                                                alertTimeSelected = alertTime.nameDesc
                                            }) {
                                                
                                                HStack {
                                                Text(alertTime.nameDesc).font(.body).foregroundColor(.black)
                                                Spacer()
                                                
                                                    if alertTimeSelected == alertTime.nameDesc {
                                                    Image(systemName: "checkmark").font(.body).foregroundColor(.blue)
                                                }
                                                }
                                            }
                                                
                                           
                                        }
                                        
                                        Spacer()
                                    }.frame(width: bounds.size.width, height: bounds.size.height * 0.95, alignment: .topLeading)
                                   
                                }
                            }
                                .onAppear(perform: {newColor = drawing.tabColor?.color ?? .red ; newCalendarName = drawing.calendarNameAdded ?? "No Name"
                                    newTaskTitle = drawing.title ?? "NO TITLE"
                                    newStartTime = drawing.startTime ?? Date()
                                    newEndTime = drawing.endTime ?? Date().addingTimeInterval(3600)
                                    
                                })
                        }
                           
                    }
                }
            }
        }
    }
    
    func updateField(canvasUUID: UUID?) {
        for drawing in drawings {
            if canvasUUID == drawing.id {
                drawing.title = newTaskTitle
                drawing.startTime = newStartTime
                drawing.endTime = newEndTime
                drawing.tabColor = SerializableColor.init(from: newColor)
                drawing.calendarNameAdded = newCalendarName
                registerNotificationAlert(title: newTaskTitle, body: "Check your task", startTime: newStartTime, offset: getOffset(nameDesc: alertTimeSelected), id: drawing.id ?? UUID())
                do {
                    try viewContext.save()
                } catch {
                    print(error.localizedDescription)
                }
                
                
            }
        }
    }
    
    
    func getOffset(nameDesc: String) -> Int {
        if nameDesc == "At time of event" {
            return 0
        }
        if nameDesc == "5 minutes before" {
            return 300
        }
        
        if nameDesc == "10 minutes before" {
            return 600
        }
        
        if nameDesc == "15 minutes before" {
            return 900
        }
        if nameDesc == "30 minutes before" {
            return 1800
        }
        
        if nameDesc == "1 hour before" {
            return 3600
        }
        
        if nameDesc == "2 hours before" {
            return 7200
        }
        
        return 0
    }
    
    
    func registerNotificationAlert(title: String, body: String, startTime: Date, offset: Int, id: UUID) {
        let content = UNMutableNotificationContent()
        let userNotificationCenter = UNUserNotificationCenter.current()
        var offsethour = 0
        var offsetminutes = 0
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default
        
        var dateInfo = DateComponents()
        
        if offset >= 3600 {
            offsethour = Int(offset / 3600)
            offsetminutes = offset - (offsethour * 3600)
        } else {
            offsetminutes = offset
        }
        dateInfo.hour = (Int(startTime.toString(dateFormat: "HH")) ?? 0) - (offsethour)
        dateInfo.minute = (Int(startTime.toString(dateFormat: "mm")) ?? 0) - (offsetminutes / 60)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: false)
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: id.uuidString, content: content, trigger: trigger)
//        let request = UNNotificationRequest(identifier: "testNotification",
//                                            content: content,
//                                                trigger: trigger)
        
        userNotificationCenter.add(request) { (error) in
            if let error = error {
                print("Notification Error: ", error)
            }
        }
        
        print("Added Notification \(dateInfo.hour), \(dateInfo.minute)")
    }
    
    
    func deleteAudio(audioURL: String) {
        let audioPath = documentsPath.appendingPathComponent(audioURL)
        
        
        
        guard fileManager.fileExists(atPath: audioPath.path) else {
            print("Audio does not exist at path: \(String(describing: audioPath))")
            return
        }
        
        do {
            try fileManager.removeItem(at: audioPath)
            print("\(String(describing: audioPath)) was deleted")
        } catch let error as NSError {
            print("Could not delete \(String(describing: audioPath)): \(error)")
        }
    }
}

struct EditTaskViewSideBarAudio_Previews: PreviewProvider {
    static var previews: some View {
        EditTaskViewSideBarAudio()
    }
}
