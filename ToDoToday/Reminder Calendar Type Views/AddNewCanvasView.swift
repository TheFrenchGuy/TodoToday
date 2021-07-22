//
//  AddNewCanvasView.swift
//  ToDoToday
//
//  Created by Noe De La Croix on 21/07/2021.
//

import SwiftUI


class eventTimeClass {
    var eventDue:Date
    
    init() {
        self.eventDue = Date()
        
    }
}

extension eventTimeClass: Equatable {
    static func == (lhs: eventTimeClass, rhs: eventTimeClass) -> Bool {
        return lhs.eventDue == rhs.eventDue
    }
    
    
}

struct AddNewCanvasView: View {
    
    @Environment (\.managedObjectContext) var viewContext
    @Environment (\.presentationMode) var presentationMode
    
    @State private var canvasTitle = ""
    
    
    @State private var eventTime = Date()
    
    @State private var eventtimeclass = eventTimeClass()
    
    @State var showPopupAlert: Bool = false
    
    var body: some View {
        NavigationView{
            Form{
                Section{
                    TextField("Canvas Title", text: $canvasTitle)
                }
                
                Section {
                    DatePicker("Time of event", selection: $eventtimeclass.eventDue, displayedComponents: .hourAndMinute).onChange(of: eventtimeclass.eventDue, perform: {value in
                        if eventtimeclass.eventDue.timeIntervalSince(Date()) < 0 {
                            print("Event due is trying to be put in the past")
                            eventtimeclass.eventDue = Date().addingTimeInterval(3600)
                            showPopupAlert.toggle()
                        }
                    })
                }.alert(isPresented: $showPopupAlert) {
                    Alert(title: Text("Well if your trying to set a due date in the past you are late"))
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .navigationTitle(Text("Add New Canvas"))
            .navigationBarItems(leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Image(systemName: "xmark")
            }), trailing: Button(action: {
                if !canvasTitle.isEmpty{
                    let drawing = DrawingCanvas(context: viewContext)
                    drawing.title = canvasTitle
                    drawing.timeEvent = eventtimeclass.eventDue
                    drawing.id = UUID()
                    
                    do {
                        try viewContext.save()
                    }
                    catch{
                        print(error)
                    }
                    
                    self.presentationMode.wrappedValue.dismiss()
                }
            }, label: {
                Text("Save")
            }))
        }
    }
}

struct AddNewCanvasView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewCanvasView()
    }
}


