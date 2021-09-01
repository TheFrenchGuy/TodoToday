//
//  TodayCanvasIphoneView.swift
//  ToDoToday
//
//  Created by Noe De La Croix on 25/08/2021.
//

import SwiftUI
import UIKit


struct TodayCanvasIphoneView: View {
    
//    var interstitial:Interstitial
//
//    init(){
//        self.interstitial = Interstitial()
//    }

    
    
    var body: some View {
        
        HStack {
            Text("Hey")
            BannerVC().frame(width: 320, height: 50, alignment: .center)
        }
    }
}

struct TodayCanvasIphoneView_Previews: PreviewProvider {
    static var previews: some View {
        TodayCanvasIphoneView()
    }
}
