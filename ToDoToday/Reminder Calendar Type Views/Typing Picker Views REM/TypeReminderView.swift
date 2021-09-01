//
//  Type Reminder View.swift
//  ToDoToday
//
//  Created by Noe De La Croix on 29/07/2021.
//

import SwiftUI

class updatedTaskDesClass {
    var newTaskDesc: String
    var newTaskTitle: String
    var newTaskUUID: UUID
    
    init() {
        self.newTaskDesc = ""
        self.newTaskTitle = ""
        self.newTaskUUID = UUID()
    }
}

extension updatedTaskDesClass: Equatable {
    static func == (lhs: updatedTaskDesClass, rhs: updatedTaskDesClass) -> Bool {
       
        return lhs.newTaskDesc == rhs.newTaskDesc
        
    }
    
    
}

struct TypeReminderView: View {
     var title: String
     var text: String
     var remUUID: UUID
     var tabColor: UIColor
     var completedTask: Bool
    
    @State var startTime: Date = Date()
    @State var endTime: Date = Date().addingTimeInterval(3600)
    
    @State var showSettings: Bool = false
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(entity: DrawingCanvas.entity(), sortDescriptors: []) var drawings: FetchedResults<DrawingCanvas>
    @EnvironmentObject var tabViewClass: TabViewClass
    
    @State private var showSheet: Bool = false
    
    @State private var updatedTask = updatedTaskDesClass()
    
    var heightTime: CGFloat
    
    var windowSize:CGSize
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 6).foregroundColor(Color(tabColor)).frame(height: 7)
            
            Button(action: {
//                showSheet.toggle()
                tabViewClass.editTask.toggle()
                tabViewClass.editTaskUUID = remUUID
                tabViewClass.taskType = TypeReminder.typed.rawValue
            }) {
                VStack {
                    Spacer()
                    
                    if self.completedTask {
                        Text(title).bold().strikethrough()
                        Text(text).strikethrough()
                    } else {
                        Text(title).bold()
                        Text(text)
                    }
                    Spacer()
                   
                }.foregroundColor(.black )
                
                
            
            }
//            .sheet(isPresented: $showSheet) {
//
//                if !showSettings {
//                VStack {
//                    Text("Title:")
//                    TextEditor(text: $updatedTask.newTaskTitle)
//                    Text("Task Description:")
//                    TextEditor(text: $updatedTask.newTaskDesc)
//                        .onChange(of:updatedTask.newTaskDesc, perform: { value in
//                            updateField(canvasUUID: remUUID)
//                        })
//
//                        .onChange(of:updatedTask.newTaskTitle, perform: { value in
//                            updateField(canvasUUID: remUUID)
//                        })
//
//                    Spacer()
//
//                    HStack {
//                        Button(action: {showSheet.toggle()}) {
//                            Text("Dismiss me")
//
//                        }.padding(.leading, 50)
//
//
//                        Spacer()
//                        Button(action: {
//                            withAnimation() {
//                                self.showSettings = true
//
//                            }
//
//                        }) { Image(systemName: "slider.horizontal.3")}.padding(.trailing, 50)
//
//
//                    }.frame(height: 50)
//
//                }.onAppear(perform: {updatedTask.newTaskDesc = text; updatedTask.newTaskTitle = title})
//                } else {
//                    VStack(alignment: .leading) {
//
//                        Button(action: {
//
//                            withAnimation() {
//                                self.showSettings = false
//                            }
//
//                        }) {
//                            HStack{
//                                Image(systemName: "chevron.backward")
//                                Text("Back to drawing")
//                                Spacer()
//                            }
//                        }.padding()
//                       // .padding(.bottom, 40)
//
//                        Text("What would you like to modifiy about your task?").font(.title2).bold().padding()
//
//
//
//                        Form {
//
//
//                            Section(header: Text("Title")) {
//
//
//                                VStack(alignment: .leading) {
//                                    Text("Title of your task:")
//                                    HStack() {
//                                        Spacer()
//                                        TextField("Title of Task", text: $title)
//                                    }
//                                }.padding()
//
//                            }
//
//
//                            Section(header: Text("Timings")) {
//
//                                DatePicker("Start of Event", selection: $startTime).padding()
//                                DatePicker("Completion Time of Event", selection: $endTime ).padding()
//                            }
//
//
//                            Section(header: Text("Make sure you delayed the tasks being done")) {
//                            Button(action: {
//                                   updateFields()
//                            }) {
//                                HStack(alignment: .center) {
//                                    Image(systemName: "externaldrive.badge.icloud")
//                                    Text("Save update")
//
//                                }
//                            }.padding()
//
//                            }
//                        }
//                    }
//                }
//
//            }
        }.frame(height: heightTime)
        .background(RoundedRectangle(cornerRadius: 6).foregroundColor(Color(tabColor).opacity(0.6)).frame(height: heightTime))
           
        
    }
    
    func updateField(canvasUUID: UUID?) {
        for drawing in drawings {
            if canvasUUID == drawing.id {
                drawing.taskDescription = updatedTask.newTaskDesc
                drawing.title = updatedTask.newTaskTitle
                
                do {
                    try viewContext.save()
                } catch {
                    print(error.localizedDescription)
                }
                
                
            }
        }
    }
    
    
    func updateFields() {
        for drawing in drawings {
            if drawing.id == remUUID {
                drawing.title = title
                drawing.startTime = startTime
                drawing.endTime = endTime
                
                do {
                    try viewContext.save()
                  //  try viewContext.refreshAllObjects()
                    print("Saved")
                    
                }
                catch{
                    print(error)
                    print("ERROR COULDNT ADD ITEM")
                }
            }
        }
    }
}



//struct Type_Reminder_View_Previews: PreviewProvider {
//    static var previews: some View {
//        Type_Reminder_View()
//    }
//}
