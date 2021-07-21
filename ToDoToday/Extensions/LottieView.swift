//
//  LottieView.swift
//  ToDoToday
//
//  Created by Noe De La Croix on 21/07/2021.
//

import SwiftUI
import Lottie


struct LottieView: UIViewRepresentable { //To allow the JSON file to be read and to display the animaton
    //Allows link to SwiftUI from UIKit
    let animationView = AnimationView()
    var filename : String //The name of the file to be  loaded
    var speed: Double //The speed at which the animation should be played
    var loop: LottieLoopMode //Whever the animation should loop
    
    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let view = UIView()
        
        let animation = Animation.named(filename) //Loads the animation
        animationView.animation = animation //Sets the animation
        animationView.animationSpeed = CGFloat(speed) //Speed
        animationView.contentMode = .scaleAspectFit //Aspect Ratio
        animationView.loopMode = loop //Whever to loop
        animationView.play() //Plays the animation
        
            animationView
            .translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.heightAnchor
                .constraint(equalTo: view.heightAnchor),
            
            animationView.widthAnchor
                .constraint(equalTo: view.widthAnchor),
        ])
        
        return view //Necessary in order to conform to UIVieewRepresentable
        
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LottieView> ) {
    }
}


