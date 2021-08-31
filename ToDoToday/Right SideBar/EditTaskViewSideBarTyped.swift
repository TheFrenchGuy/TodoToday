//
//  EditTaskViewSideBar.swift
//  EditTaskViewSideBar
//
//  Created by Noe De La Croix on 31/08/2021.
//

import SwiftUI

struct EditTaskViewSideBarTyped: View {
    
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
    @State private var action: String = "Normal" // View should have state either of normal, alert or calendar
    
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
                                            
                                            if editTask {
                                                Text("Task Description:").font(.footnote).opacity(0.5).padding(.horizontal)
                                                TextEditor(text: $newTaskDescription).padding(.horizontal).font(.body)
                                                    .padding(.leading, 5)
                                            }
                                            
                                            else {
                                                Text("Task Description: ").font(.footnote).opacity(0.5).padding(.horizontal)
                                                Text(drawing.taskDescription ?? "NO DESCRIPTION").padding(.horizontal).font(.body)
                                                    .padding(.leading, 5)
                                            }
                                        }
                                        
                                        Divider()
                                        
                                        
                                        CalendarAlertButtonView()
                                        
                                        CalendarEditButtonView(calendarNameAdded: $newCalendarName, tabColor: $newColor, calendarMove: $action)
                                    
                                        
                                        
                                        
                                        Spacer()
                                        
                                        
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
                            }
                                .onAppear(perform: {newColor = drawing.tabColor?.color ?? .red ; newCalendarName = drawing.calendarNameAdded ?? "No Name"
                                    newTaskTitle = drawing.title ?? "NO TITLE"
                                    newStartTime = drawing.startTime ?? Date()
                                    newEndTime = drawing.endTime ?? Date().addingTimeInterval(3600)
                                    newTaskDescription = drawing.taskDescription ?? "NO TASK DESC"
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
                
                do {
                    try viewContext.save()
                } catch {
                    print(error.localizedDescription)
                }
                
                
            }
        }
    }
    
    
}




struct EditTaskViewSideBar_Previews: PreviewProvider {
    static var previews: some View {
        EditTaskViewSideBarTyped()
    }
}


struct CalendarEditButtonView: View {
    
    @Binding var calendarNameAdded: String
    @Binding var tabColor: Color
    
    @Binding var calendarMove: String
    var body: some View {
        Button(action: {
            // So that you can set the notification
            calendarMove = "Calendar"
        }) {

            HStack {
                Text("Calendar").foregroundColor(.black)


                Spacer()

                Text(calendarNameAdded).foregroundColor(.black).opacity(0.5)
                Circle().fill(tabColor).frame(width: 15, height: 15)
                Image(systemName: "chevron.right").foregroundColor(.black).opacity(0.5)


            }

        }.padding(.horizontal)
            .padding(.vertical, 5)

        Divider()
    }
}


struct CalendarAlertButtonView: View {
    var body: some View {
        Button(action: {
            // So that you can set the notification
        }) {
            
            HStack {
                Text("Alert").foregroundColor(.black)
                Image(systemName:"clock").foregroundColor(.black)
                    
                Spacer()
                
                Image(systemName: "chevron.right").foregroundColor(.black).opacity(0.5)
            
            }
            
        }.padding(.horizontal)
         .padding(.vertical, 5)

        
        
        Divider()
        
    }
}
