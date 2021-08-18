//
//  OutDatedTypedREM.swift
//  ToDoToday
//
//  Created by Noe De La Croix on 18/08/2021.
//

import SwiftUI

struct OutDatedTypedREMView: View {
    
    let title: String
    let description: String
    let dateOverDue: Date
    let width: CGFloat
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text(title)
                    Divider()
                    Text("Was due on \(dateOverDue.toString(dateFormat: "MMM d, hha"))")
                }.frame(height: 30)
                
                Text(description).frame(width: width * 0.8, height: 120)
            }.padding()
            .background(RoundedRectangle(cornerRadius: 12).foregroundColor(.white))
            .clipped()
            
          
            }
        
        
    }
}

//struct OutDatedTypedREM_Previews: PreviewProvider {
//    static var previews: some View {
//        OutDatedTypedREM()
//    }
//}
