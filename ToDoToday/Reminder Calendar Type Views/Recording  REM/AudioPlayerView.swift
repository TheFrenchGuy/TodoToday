//
//  AudioPlayer View.swift
//  ToDoToday
//
//  Created by Noe De La Croix on 02/08/2021.
//

import SwiftUI

struct AudioPlayerView: View {
    
    var title: String
    var remUUID: UUID
    var audioURL: String
    var tabColor: UIColor
    
    @ObservedObject var audioPlayer = AudioPlayer()
    
    var body: some View {
        HStack {
//            Text("\(audioURL.lastPathComponent)")
            
            Text("\(audioURL)")
            Spacer()
            if audioPlayer.isPlaying == false {
                Button(action: {
                    self.audioPlayer.startPlayback(audio: self.audioURL)
                }) {
                    Image(systemName: "play.circle")
                        .imageScale(.large)
                }
            } else {
                Button(action: {
                    self.audioPlayer.stopPlayback()
                }) {
                    Image(systemName: "stop.fill")
                        .imageScale(.large)
                }
            }
            Circle().fill(Color(tabColor))
        }
    }
}

//struct AudioPlayerView_Previews: PreviewProvider {
//    static var previews: some View {
//        AudioPlayerView()
//    }
//}
