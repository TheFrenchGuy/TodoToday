//
//  Audio Player.swift
//  ToDoToday
//
//  Created by Noe De La Croix on 02/08/2021.
//

import Foundation
import SwiftUI
import Combine
import AVFoundation

class AudioPlayer: NSObject, ObservableObject, AVAudioPlayerDelegate {
    
    let fileManager = FileManager.default
    let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    let objectWillChange = PassthroughSubject<AudioPlayer, Never>()
    
    var isPlaying = false {
        didSet {
            objectWillChange.send(self)
        }
    }
    
    var audioPlayer: AVAudioPlayer!
    
    func startPlayback (audio: String) {
        
        let playbackSession = AVAudioSession.sharedInstance()
        
        let audioPath = URL(string: documentsPath.appendingPathComponent(audio).path)!
        
        
        do {
            try playbackSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
        } catch {
            print("Playing over the device's speakers failed")
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioPath)
            audioPlayer.delegate = self
            audioPlayer.play()
            isPlaying = true
        } catch {
            print("Playback failed.")
            print(error.localizedDescription)
        }
    }
    
    func stopPlayback() {
        audioPlayer.stop()
        isPlaying = false
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            isPlaying = false
        }
    }
    
}

