//
//  EditTaskViewSideBarImage.swift
//  ToDoToday
//
//  Created by Noe De La Croix on 02/09/2021.
//

import SwiftUI

struct EditTaskViewSideBarImage: View {
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(entity: DrawingCanvas.entity(), sortDescriptors: []) var drawings: FetchedResults<DrawingCanvas>
    @EnvironmentObject var tabViewClass: TabViewClass
    
    
    @EnvironmentObject var transferColorPalette:TransferColorPalette
    
    
    @State private var updatedTask = updatedTaskDesClass()
    
    
    @State private var editTask: Bool = false
    
    @State private var newTaskTitle: String = ""
    @State private var newStartTime: Date = Date()
    @State private var newEndTime: Date = Date().addingTimeInterval(3600)
    @State private var newTaskDescription: String = ""
    @State private var newColor: Color = Color.green
    @State private var newCalendarName: String = "none"
    @State private var newCompletedTask: Bool = false
    @State private var action: String = "Normal" // View should have state either of normal, alert or calendar
    
    @State var showSheet: Bool = false
    
    
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
        registerUserNotification()
        
        
         return ZStack {
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
                                        
                                        
                                        CalendarImageButtonView(imageData: drawing.imageData ?? Data(), toggle: $showSheet)
                                        .frame(width: bounds.size.width , alignment: .center)

                                        Divider()


                                        CalendarAlertButtonView(alertMove: $action, alertTime: alertTimeSelected)

                                        CalendarEditButtonView(calendarNameAdded: $newCalendarName, tabColor: $newColor, calendarMove: $action)



                                        CalendarCompletedTaskSideBar(newCompletedTask: $newCompletedTask).frame(width: bounds.size.width, alignment: .center)
//
                                        
                                        Divider()
                                        
                                        HStack {
                                            Button(action: {
                                                //MARK: To save the changes
                                                newTaskTitle = drawing.title ?? "NO TITLE"
                                                newStartTime = drawing.startTime ?? Date()
                                                newEndTime = drawing.endTime ?? Date().addingTimeInterval(3600)
                                                newTaskDescription = drawing.taskDescription ?? "NO TASK DESC"
                                                
                                                updateField(canvasUUID: drawing.id)
                                            }) {
                                                Text("Save Changes").foregroundColor(.red)
                                            }
                                            
                                            
                                            Spacer()
                                            Button(action: {
                                                // MARK: To delete the event
                                                viewContext.delete(drawing)
                                                
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
                                }.fullScreenCover(isPresented: $showSheet, content: {FullScreenImageCalendarSubView(imageData: drawing.imageData ?? Data(), showSheet: $showSheet)})
//                                .fullScreenCover(isPresented: $showSheet, content: {
//                                    VStack {
//                                        Image(uiImage: UIImage.init(data: drawing.imageData ?? Data()) ?? UIImage(systemName: "xmark")!).resizable().scaledToFit().resizable().scaledToFit()
//
//                                        HStack {
//
//                                            Button(action: {showSheet.toggle()}) {
//                                                Text("Dismiss me")
//
//                                            }.padding(.leading, 50)
//
//
//                                            Spacer()
//
//
//
//                                        }.frame(height: 50, alignment: .bottom)
//
//
//                                    }
//                                })
                                
                                
                            
                                .onAppear(perform: {newColor = drawing.tabColor?.color ?? .red ; newCalendarName = drawing.calendarNameAdded ?? "No Name"
                                    newTaskTitle = drawing.title ?? "NO TITLE"
                                    newStartTime = drawing.startTime ?? Date()
                                    newEndTime = drawing.endTime ?? Date().addingTimeInterval(3600)
                                    newTaskDescription = drawing.taskDescription ?? "NO TASK DESC"
                                    newCompletedTask = drawing.completedTask
                                    alertTimeSelected = drawing.alertNotificationTimeBefore ?? ""
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
                drawing.taskDescription = newTaskDescription
                drawing.title = newTaskTitle
                drawing.startTime = newStartTime
                drawing.endTime = newEndTime
                drawing.tabColor = SerializableColor.init(from: newColor)
                drawing.calendarNameAdded = newCalendarName
                drawing.completedTask = newCompletedTask
                drawing.alertNotificationTimeBefore = alertTimeSelected
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
        
//        print("Added Notification \(dateInfo.hour), \(dateInfo.minute)")
    }
    
    func registerUserNotification() {
        
        
            UNUserNotificationCenter.current()
                .requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        print("All Set!")
                    } else if let error = error {
                        print(error.localizedDescription)
                        print("Failed")
                    }
            }
            
            
    }
}

struct EditTaskViewSideBarImage_Previews: PreviewProvider {
    static var previews: some View {
        EditTaskViewSideBarImage()
    }
}
struct CalendarImageButtonView: View {
    
    var imageData: Data
    @Binding var toggle: Bool
    var body: some View {
        VStack(alignment: .center) {
            Button(action: {toggle.toggle()}) {
            Image(uiImage: UIImage.init(data: imageData) ?? UIImage(systemName: "xmark")!).resizable().scaledToFit()
            }
        }
        
    }
}

struct CalendarEditTaskSubView: View {
    
    var imageData: Data
    @Binding var showSheet: Bool
    var size: CGSize
    @Binding var action: String
    @Binding var newCalendarName: String
    @Binding var newColor: Color
    @Binding var newCompletedTask: Bool
    var alertTimeSelected: String
    
    var body: some View {
        VStack {
                CalendarImageButtonView(imageData: imageData , toggle: $showSheet)
               .frame(width: size.width , alignment: .center)

               Divider()


               CalendarAlertButtonView(alertMove: $action, alertTime: alertTimeSelected)

               CalendarEditButtonView(calendarNameAdded: $newCalendarName, tabColor: $newColor, calendarMove: $action)



               CalendarCompletedTaskSideBar(newCompletedTask: $newCompletedTask).frame(width: size.width, alignment: .center)
            
        }
    }
}

struct FullScreenImageCalendarSubView: View {
    
    var imageData: Data
    @Binding var showSheet: Bool
    
    
    var body: some View {
        VStack {
            Image(uiImage: UIImage.init(data: imageData)!).resizable().scaledToFit()
            
            HStack {
                
                Button(action: {showSheet.toggle()}) {
                    Text("Dismiss me")
                    
                }.padding(.leading, 50)
                
                
                Spacer()
                
                
            }.frame(height: 50, alignment: .bottom)
            
            
        }
    }
}
