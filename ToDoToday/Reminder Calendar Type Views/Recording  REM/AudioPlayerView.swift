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
    
    var windowSize:CGSize
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 6).foregroundColor(Color(tabColor)).frame(height: windowSize.height / 15)
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
               
            }
        }.background(RoundedRectangle(cornerRadius: 6).foregroundColor(Color(tabColor).opacity(0.6)))
    }
}

//struct AudioPlayerView_Previews: PreviewProvider {
//    static var previews: some View {
//        AudioPlayerView()
//    }
//}
