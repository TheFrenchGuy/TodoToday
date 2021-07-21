//
//  iCloudSyncView.swift
//  ToDoToday
//
//  Created by Noe De La Croix on 21/07/2021.
//

import SwiftUI

struct iCloudSyncView: View {
    @State private var enableiCloudSync = true
    var body: some View {
        ZStack {
            GeometryReader { bounds in
                VStack() {
                    Image(systemName: "icloud").resizable().scaledToFit()
                        .frame(width: bounds.size.width * 0.2).padding(.top, bounds.size.height * 0.1)
                    Spacer()
                    VStack {
                    Toggle("Do you want to enable iCloud sync so that your todo list is shared to all of your devices?", isOn: $enableiCloudSync)
                    }
                        .frame(width: bounds.size.width * 0.8, alignment: .leading)
                            .padding()
                           .background(RoundedRectangle(cornerRadius: 15).opacity(0.15))
                          
                    
                    Text("Tip: If I was you, I would it makes the app a much better experience").font(.footnote).foregroundColor(.gray)
                        .frame(width: bounds.size.width * 0.8, alignment: .leading)
                        .padding(.bottom, bounds.size.height * 0.1)
                }.frame(width: bounds.size.width, height: bounds.size.height)
            }
        }
    }
}

//struct iCloudSyncView_Previews: PreviewProvider {
//    static var previews: some View {
//        if #available(iOS 15.0, *) {
//            iCloudSyncView()
//                .previewInterfaceOrientation(.landscapeLeft)
//        } else {
//            // Fallback on earlier versions
//        }
//    }
//}
