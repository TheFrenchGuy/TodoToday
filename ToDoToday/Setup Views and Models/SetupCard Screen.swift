//
//  SetupCard Screen.swift
//  ToDoToday
//
//  Created by Noe De La Croix on 21/07/2021.
//

import SwiftUI

struct SetupCard_Screen: View {
    @State var swippedUp = false
    var body: some View {
        let drag = DragGesture()
            .onEnded { _ in // The user could swipe in any direction and it would owrk and would go to the next stage
                withAnimation() { self.swippedUp = true }
            }
        if !swippedUp {
        ZStack {
        GeometryReader { bounds in
            ZStack(alignment: .center){
                Text("Ready to elevate your to do list?").font(.system(size: 38, weight: .bold, design: .default))
                    .padding(.bottom, bounds.size.width * 0.7)
                VStack() {
                    LottieView(filename: "GoingofPlaneLottie", speed: 1.0, loop: .loop)
                    
                    LottieView(filename: "SwipeUpLottie", speed: 0.7, loop: .loop)
                        .opacity(0.7)
                        .frame(width: bounds.size.width * 0.10, height: bounds.size.height * 0.1)
                }
                
                
                    
                        
            }.gesture(drag)
            
            }
        }
        }
        else {
            ListTypeSetupView() //Go to the tabview where the settings will be sent
        }
    
        
    }
}

struct SetupCard_Screen_Previews: PreviewProvider {
    static var previews: some View {
        SetupCard_Screen()
    }
}




