//
//  SideBar.swift
//  ToDoToday
//
//  Created by Noe De La Croix on 06/08/2021.
//

import SwiftUI

struct SideBarView: View {
    var body: some View {
        List {
            CheckboxField(id: "Calendar1", label: "Calendar1", callback: checkboxSelected)
            CheckboxField(id: "Calendar2", label: "Calendar2", callback: checkboxSelected)
            CheckboxField(id: "Calendar3", label: "Calendar3", callback: checkboxSelected)
            CheckboxField(id: "Calendar4", label: "Calendar4", callback: checkboxSelected)
        }
    }
        
    
    func checkboxSelected(id: String, isMarked: Bool) {
            print("\(id) is marked: \(isMarked)")
        }
}

//struct SideBar_Previews: PreviewProvider {
//    static var previews: some View {
//        SideBarView()
//    }
//}


struct CheckboxField: View {
    let id: String
    let label: String
    let size: CGFloat
    let color: Color
    let textSize: Int
    let callback: (String, Bool)->()
    
    init(
        id: String,
        label:String,
        size: CGFloat = 10,
        color: Color = Color.black,
        textSize: Int = 14,
        callback: @escaping (String, Bool)->()
        ) {
        self.id = id
        self.label = label
        self.size = size
        self.color = color
        self.textSize = textSize
        self.callback = callback
    }
    
    @State var isMarked:Bool = false
    
    var body: some View {
        Button(action:{
            self.isMarked.toggle()
            self.callback(self.id, self.isMarked)
        }) {
            HStack(alignment: .center, spacing: 10) {
                Image(systemName: self.isMarked ? "checkmark.square" : "square")
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: self.size, height: self.size)
                Text(label)
                    .font(Font.system(size: size))
                Spacer()
            }.foregroundColor(self.color)
        }
        .foregroundColor(Color.white)
    }
}
