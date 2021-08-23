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
    
    @Binding var isVisible: Bool
    
    @State var id:UUID?
    @State var data:Data?
    @State var title:String?
    @State var startTime: Date?
    var body: some View {
        VStack{
            if id?.uuidString == "" {
            Text("NO UUID STRING ASSIGNED \(title ?? "NO TITLE")")
            } else {
//                Text("\(id ?? UUID()), \(title ?? "NO TITLE")")
                Text("\((startTime?.toString(dateFormat: "d, hha, mm"))!)")
                DrawingCanvasView(data: data ?? Data(), id: id ?? UUID())
                    .environment(\.managedObjectContext, viewContext)
                    .navigationBarTitle(title ?? "Untitled",displayMode: .inline)
            }
            
            Button(action: {self.isVisible = false}) { Text("Dismiss me")}
        }
    }
}
