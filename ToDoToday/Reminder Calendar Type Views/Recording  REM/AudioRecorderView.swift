//
//  AudioRecorderView.swift
//  ToDoToday
//
//  Created by Noe De La Croix on 01/08/2021.
//

import SwiftUI

struct AudioRecorderView: View {
    
    @EnvironmentObject var audioRecorder: AudioRecorder
    
    
    
    var body: some View {
        LazyVStack {
                    if audioRecorder.recording == false {
                        Button(action: {self.audioRecorder.startRecording()}) {
                            Image(systemName: "circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 100, height: 100)
                                .clipped()
                                .foregroundColor(.red)
                                .padding(.bottom, 40)
                        }
                    } else {
                        Button(action: {audioRecorder.stopRecording()}) {
                            Image(systemName: "stop.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 100, height: 100)
                                .clipped()
                                .foregroundColor(.red)
                                .padding(.bottom, 40)
                        }
                    }
                }
//        .onAppear(perform: {updatedtaskAudio.newURL = URL(string: "http://dumdum.com/")!})
    }
}

//struct AudioRecorderView_Previews: PreviewProvider {
//    static var previews: some View {
//        AudioRecorderView()
//    }
//}
