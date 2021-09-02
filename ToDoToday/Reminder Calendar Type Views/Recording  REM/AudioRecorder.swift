//
//  AudioRecorder.swift
//  ToDoToday
//
//  Created by Noe De La Croix on 01/08/2021.
//

import Foundation
import SwiftUI
import Combine
import AVFoundation
import CoreData


class updatedTaskAudioClass: ObservableObject {
//    @Published var newURL: URL = URL(string: "http://nshipster.com/")!
    
    @Published var newURL: String = "NO URL"
    
}


class AudioRecorder: ObservableObject {
    
    let objectWillChange = PassthroughSubject<AudioRecorder, Never>()
    
    var audioRecorder: AVAudioRecorder!
    
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(entity: DrawingCanvas.entity(), sortDescriptors: []) var drawings: FetchedResults<DrawingCanvas>
    
//    @Published var newURL: URL = URL(string: "http://nshipster.com/")!
//    @Published var newURL: URL = URL(string: "nourl.com")!
    @Published var newURL: String = "NO URL"
    @Published var fullURL: URL = URL(string: "nourl.com")!
    
   // @EnvironmentObject var updatedTaskAudio: updatedTaskAudioClass
    var recording = false {
            didSet {
                objectWillChange.send(self)
            }
        }
    
    
    func startRecording() {
        let recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
        } catch {
            print("Failed to set up recording session")
        }
        
        
        
        
        
        
//        let documentPath = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents")
//
//        let audioFilename =  documentPath?.appendingPathComponent("\(Date().toString(dateFormat: "dd-MM-YY_'at'_HH:mm:ss")).m4a")
        
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let audioFilename = documentPath.appendingPathComponent("\(Date().toString(dateFormat: "dd-MM-YY_'at'_HH:mm:ss")).m4a")
//        let soundURL = documentPath.appendingPathComponent("capturedAudio.m4a")
        
        
       
        
        
        
        
        newURL = String("\(Date().toString(dateFormat: "dd-MM-YY_'at'_HH:mm:ss")).m4a")
        fullURL = audioFilename
        
        print(fullURL.absoluteString)
        
        let settings = [
        
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
//        let fileURL = documentPath!.appendingPathComponent("test.txt")
//
//        try? "Hello word".data(using: .utf8)?.write(to: fileURL)
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.record()
            
            
           
            
//            print("RECORDING SAVED \(fileURL)")

            recording = true
        } catch {
            print("Could not start recording")
        }
    }

    
    func stopRecording() {
//           audioRecorder.stop()
           recording = false
            
       }
}

extension Date
{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }

}
