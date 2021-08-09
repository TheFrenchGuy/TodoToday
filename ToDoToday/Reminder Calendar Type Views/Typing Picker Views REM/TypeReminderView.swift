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
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(entity: DrawingCanvas.entity(), sortDescriptors: []) var drawings: FetchedResults<DrawingCanvas>

    
    @State private var showSheet: Bool = false
    
    @State private var updatedTask = updatedTaskDesClass()
    
    var windowSize:CGSize
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 6).foregroundColor(Color(tabColor)).frame(height: windowSize.height / 15)
            
            Button(action: {
                showSheet.toggle()
            }) {
                VStack {
                    Text(title)
                    Text(text)
                   
                }
            }.sheet(isPresented: $showSheet) {
                VStack {
                    Text("Title:")
                    TextEditor(text: $updatedTask.newTaskTitle)
                    Text("Task Description:")
                    TextEditor(text: $updatedTask.newTaskDesc)
                        .onChange(of:updatedTask.newTaskDesc, perform: { value in
                            updateField(canvasUUID: remUUID)
                        })
                    
                        .onChange(of:updatedTask.newTaskTitle, perform: { value in
                            updateField(canvasUUID: remUUID)
                        })
                }.onAppear(perform: {updatedTask.newTaskDesc = text; updatedTask.newTaskTitle = title})
                
            }
        }.background(RoundedRectangle(cornerRadius: 6).foregroundColor(Color(tabColor).opacity(0.6)))
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
}



//struct Type_Reminder_View_Previews: PreviewProvider {
//    static var previews: some View {
//        Type_Reminder_View()
//    }
//}
