//
//  InitialCanvasDrawingView.swift
//  ToDoToday
//
//  Created by Noe De La Croix on 26/07/2021.
//

import SwiftUI

struct InitialCanvasDrawingView: View {
    
    
    @Environment (\.presentationMode) var presentationMode
    
    @State var id: UUID?
    @State var data:Data?
    @State var title: String?
    
    
    var body: some View {
        Text("\(id ?? UUID()), \(title ?? "NO TITLE")")
        DrawingCanvasView(data: data ?? Data(), id: id ?? UUID())
        Button(action: {self.presentationMode.wrappedValue.dismiss()}) { Text("Dismiss me")}
    }
}

struct InitialCanvasDrawingView_Previews: PreviewProvider {
    static var previews: some View {
        InitialCanvasDrawingView()
    }
}
