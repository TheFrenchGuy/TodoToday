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
    var body: some View {
        VStack{
            Text("\(id ?? UUID()), \(title ?? "NO TITLE")")
            DrawingCanvasView(data: data ?? Data(), id: id ?? UUID())
                .environment(\.managedObjectContext, viewContext)
                .navigationBarTitle(title ?? "Untitled",displayMode: .inline)
            
            Button(action: {self.isVisible = false}) { Text("Dismiss me")}
        }
    }
}
