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



extension View {
    func hidden(_ shouldHide: Bool) -> some View {
        opacity(shouldHide ? 0 : 1)
    }
}



struct AddNewCanvasView: View {
    
    @Environment (\.managedObjectContext) var viewContext
    @Environment (\.presentationMode) var presentationMode
    
    @State private var canvasTitle = ""
    
    
    @State private var eventTime = Date()
    
    @State private var eventtimeclass = eventTimeClass()
    
    @State var showPopupAlert: Bool = false
    
    @Binding var AddedNewCanvas: Bool
    
    
    @State private var showingCanvas: Bool = false
    @State private var showingTypeInterface: Bool = false
    
    
    @State private var typeReminder = TypeReminder.drawing
    @State private var initialUUID: UUID = UUID()
    
    
    @State private var REMDescription: String = ""
    var body: some View {
        ZStack {
            
        NavigationView{
            VStack {
            Form{
                Section{
                    TextField("Canvas Title", text: $canvasTitle)
                    
                }
                
                Section {
                    VStack(alignment: .leading, spacing: 10) {
                    Text("Type of reminder:")
                        Picker("What type of reminder will it be", selection: $typeReminder, content: {
                            ForEach(TypeReminder.allCases, content: { typeRem in
                                Text(typeRem.rawValue)
                            })
                        }).pickerStyle(SegmentedPickerStyle())
                    }
                }
                
                
                if typeReminder.rawValue == TypeReminder.typed.rawValue {
                    Section {
                 
                        TextField("What your reminder / event", text: $REMDescription)
                    }
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
                NavigationLink(destination: InitialCanvasDrawingView(id: initialUUID, title: canvasTitle), isActive: $showingCanvas) {EmptyView()}.hidden(showingCanvas)
                NavigationLink(destination: Text("TYPING REMINDER VIEW"), isActive: $showingTypeInterface) {EmptyView()}.hidden(showingTypeInterface)
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .navigationTitle(Text("Add New Canvas"))
            .navigationBarItems(leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Image(systemName: "xmark")
            }), trailing:
                                    Button(action: {
                if !canvasTitle.isEmpty && typeReminder.rawValue == TypeReminder.drawing.rawValue{
                    let drawing = DrawingCanvas(context: viewContext)
                    let date: Date = (Calendar.current.date(bySettingHour: 0, minute: 0, second: 0 , of: Date())!)
                    
                    let timediff = Int(eventtimeclass.eventDue.timeIntervalSince(date))
                    print("TIME DIFFERENCE OF \(timediff)")
                    drawing.title = canvasTitle
                    drawing.timeEvent = eventtimeclass.eventDue
                    drawing.id = UUID()
                    drawing.typeRem = typeReminder.rawValue
                    initialUUID = drawing.id!
                    
                    do {
                        AddedNewCanvas.toggle()
                        try viewContext.save()
                      //  try viewContext.refreshAllObjects()
                        
                    }
                    catch{
                        print(error)
                        print("ERROR COULDNT ADD ITEM")
                    }
                    
                    //self.presentationMode.wrappedValue.dismiss()
                    
                    showingCanvas.toggle()
                }
                
                else if !canvasTitle.isEmpty && typeReminder.rawValue == TypeReminder.typed.rawValue && !REMDescription.isEmpty{
                    let drawing = DrawingCanvas(context: viewContext)
                    let date: Date = (Calendar.current.date(bySettingHour: 0, minute: 0, second: 0 , of: Date())!)
                    
                    let timediff = Int(eventtimeclass.eventDue.timeIntervalSince(date))
                    print("TIME DIFFERENCE OF \(timediff)")
                    drawing.title = canvasTitle
                    drawing.timeEvent = eventtimeclass.eventDue
                    drawing.id = UUID()
                    drawing.typeRem = typeReminder.rawValue
                    drawing.taskDescription = REMDescription
                    initialUUID = drawing.id!
                    
                    do {
                        AddedNewCanvas.toggle()
                        try viewContext.save()
                      //  try viewContext.refreshAllObjects()
                        
                    }
                    catch{
                        print(error)
                        print("ERROR COULDNT ADD ITEM")
                    }
                    
                    self.presentationMode.wrappedValue.dismiss()
                    
//                    showingTypeInterface.toggle()
                }
                
            }, label: {
                Text("Next")
            }))
                
        }
        }
    }
}

//struct AddNewCanvasView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddNewCanvasView()
//    }
//}


