//
//  SetupCard_Screen_Iphone.swift
//  SetupCard_Screen_Iphone
//
//  Created by Noe De La Croix on 30/08/2021.
//

import SwiftUI

struct SetupCard_Screen_Iphone: View {
    
    @State var swippedUp = false
    
    var body: some View {
        let drag = DragGesture()
            .onEnded { _ in // The user could swipe in any direction and it would owrk and would go to the next stage
                withAnimation() { self.swippedUp = true }
            }
        if !swippedUp {
        ZStack {
        GeometryReader { bounds in
            VStack(alignment: .center){
                Spacer()
                Text("Ready to elevate your to do list?").font(.system(size: 38, weight: .bold, design: .default))
                    .padding(.bottom, bounds.size.height * 0.1)
                    .padding(.top, bounds.size.height * 0.1)
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
            ListTypeSetupView_iPhone() //Go to the tabview where the settings will be sent
        }
    }
}

struct SetupCard_Screen_Iphone_Previews: PreviewProvider {
    static var previews: some View {
        SetupCard_Screen_Iphone()
    }
}
