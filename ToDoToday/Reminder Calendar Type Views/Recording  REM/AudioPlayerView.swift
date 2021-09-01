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
    var completedTask: Bool
    
    @ObservedObject var audioPlayer = AudioPlayer()
    @EnvironmentObject var tabViewClass: TabViewClass
    
    var windowSize:CGSize
    
    var heightTime: CGFloat
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 6).foregroundColor(Color(tabColor)).frame(height: 7)
            Spacer()
            HStack {
    //            Text("\(audioURL.lastPathComponent)")
                
                
                
                Button(action: {
                    tabViewClass.editTask.toggle()
                    tabViewClass.editTaskUUID = remUUID
                    tabViewClass.taskType = TypeReminder.audio.rawValue
                }) {
                    HStack {
                        if self.completedTask {
                            Text("\(title)").foregroundColor(.black).strikethrough()
                        } else {
                            Text("\(title)").foregroundColor(.black)
                        }
                    Spacer()
                    }
                }
                if audioPlayer.isPlaying == false {
                    Button(action: {
                        self.audioPlayer.startPlayback(audio: self.audioURL)
                    }) {
                        Spacer()
                        Image(systemName: "play.circle")
                            .imageScale(.large)
                        Spacer()
                    }
                } else {
                    Button(action: {
                        self.audioPlayer.stopPlayback()
                    }) {
                        Spacer()
                        Image(systemName: "stop.fill")
                            .imageScale(.large)
                        Spacer()
                    }
                }
                
                
               
            }
            
            Spacer()
        }.frame(height: heightTime)
        .background(RoundedRectangle(cornerRadius: 6).foregroundColor(Color(tabColor).opacity(0.6)))
    }
}

//struct AudioPlayerView_Previews: PreviewProvider {
//    static var previews: some View {
//        AudioPlayerView()
//    }
//}
