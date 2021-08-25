//
//  DrawingView.swift
//  ToDoToday
//
//  Created by Noe De La Croix on 21/07/2021.
//

import Foundation
import SwiftUI

struct DrawingView: View {
    
    @Environment(\.managedObjectContext) var viewContext
    
    @FetchRequest(entity: DrawingCanvas.entity(), sortDescriptors: []) var drawings: FetchedResults<DrawingCanvas>
    
    @Binding var isVisible: Bool
    
    @State var id:UUID? = UUID()
    @State var data:Data? = Data()
    @State var title:String = "NO TITLE"
    @State var startTime: Date = Date()
    @State var endTime: Date = Date().addingTimeInterval(3600)
    
    
    @State var showSettings: Bool = false
    var body: some View {
        
        if !showSettings {
            VStack{
                if id?.uuidString == "" {
                    Text("NO UUID STRING ASSIGNED \(title)")
                } else {
    //                Text("\(id ?? UUID()), \(title ?? "NO TITLE")")
//                    Text("\((startTime.toString(dateFormat: "d, hha, mm")))")
                    Text("Title: \(title)").font(.largeTitle).bold()
                    DrawingCanvasView(data: data ?? Data(), id: id ?? UUID())
                        .environment(\.managedObjectContext, viewContext)
                        .navigationBarTitle(title ,displayMode: .inline)
                }
                HStack {
                    Button(action: {self.isVisible = false}) { Text("Dismiss me")}.padding(.leading, 50)
                    Spacer()
                    Button(action: {
                        withAnimation() {
                            self.showSettings = true
                            
                        }
                        
                    }) { Image(systemName: "slider.horizontal.3")}.padding(.trailing, 50)
                }.frame(height: 50)
            }
        } else {
            
            VStack(alignment: .leading) {
                Button(action: {
                    
                    withAnimation() {
                        self.showSettings = false
                    }
                
                }) {
                    HStack{
                        Image(systemName: "chevron.backward")
                        Text("Back to drawing")
                        Spacer()
                    }
                }.padding()
               // .padding(.bottom, 40)
                
                Text("What would you like to modifiy about your task?").font(.title2).bold().padding()
                
                
                TextField("Title of Task", text: $title)
                
                DatePicker("Start of Event", selection: $startTime)
                DatePicker("Completion Time of Event", selection: $endTime )
                
                Spacer()
                
                
                Button(action: {
                       updateFields()
                }) {
                    HStack(alignment: .center) {
                        Image(systemName: "externaldrive.badge.icloud")
                        Text("Save update")
                        
                    }
                }.padding()
            }
            
        }
    }
    
    
    func updateFields() {
        for drawing in drawings {
            if drawing.id == id {
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
