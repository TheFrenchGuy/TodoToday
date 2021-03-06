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
import CoreData
import Combine

class AudioPlayer: NSObject, ObservableObject, AVAudioPlayerDelegate {
    
    let fileManager = FileManager.default
    let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
//    let documentsPath = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents")
    
    let objectWillChange = PassthroughSubject<AudioPlayer, Never>()
    
    var isPlaying = false {
        didSet {
            objectWillChange.send(self)
        }
    }
    
    var audioPlayer: AVAudioPlayer!
    
    func startPlayback (audio: String) {
        
        let playbackSession = AVAudioSession.sharedInstance()
        
        let audioPath = documentsPath.appendingPathComponent(audio)
//            URL(string: documentsPath!.appendingPathComponent(audio)) ?? URL(string: "google.com")
        print("audioPath: \(audioPath)")
//
        
        do {
            try playbackSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
        } catch {
            print("Playing over the device's speakers failed")
        }
        
        do {
//            audioPlayer = try AVAudioPlayer.init(data: audio)
            audioPlayer = try AVAudioPlayer(contentsOf: audioPath)
            audioPlayer.delegate = self
            audioPlayer.play()
            isPlaying = true
        } catch {
            print("Playback failed.")
            print(error)
        }
    }
    
    
    func startPlaybackData (audio: Data) {
        
        let playbackSession = AVAudioSession.sharedInstance()
        
        do {
            try playbackSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
        } catch {
            print("Playing over the device's speakers failed")
        }
        
        do {
            
            print( "Audio Desc: \(audio.description)")
            audioPlayer = try AVAudioPlayer.init(data: audio, fileTypeHint: "public.m4a")
            audioPlayer.delegate = self
            audioPlayer.play()
            isPlaying = true
        } catch {
            print("Playback failed.")
//            print(NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true).last!);

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

