//
//  OutDatedAudioREMView.swift
//  ToDoToday
//
//  Created by Noe De La Croix on 18/08/2021.
//

import SwiftUI

struct OutDatedAudioREMView: View {
    
    let audioURL: String
    let title: String
    let dateOverDue: Date
    let width: CGFloat
    
    
    @ObservedObject var audioPlayer = AudioPlayer()
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text(title)
                    Divider()
                    Text("Was due on \(dateOverDue.toString(dateFormat: "MMM d, hha"))")
                }.frame(height: 30)
                
                
                if audioPlayer.isPlaying == false {
                    Button(action: {
                        self.audioPlayer.startPlayback(audio: audioURL)
                    }) {
                        Image(systemName: "play.circle")
                            .imageScale(.large)
                    }.frame(width: width * 0.8, height: 120)
                } else {
                    Button(action: {
                        self.audioPlayer.stopPlayback()
                    }) {
                        Image(systemName: "stop.fill")
                            .imageScale(.large)
                    } .frame(width: width * 0.8, height: 120)
                }
                
                
               
            }.padding()
            .background(RoundedRectangle(cornerRadius: 12).foregroundColor(.white))
            .clipped()
            
          
            }
    }
}

//struct OutDatedAudioREMView_Previews: PreviewProvider {
//    static var previews: some View {
//        OutDatedAudioREMView()
//    }
//}
