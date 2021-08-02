//
//  HoursView.swift
//  ToDoToday
//
//  Created by Noe De La Croix on 23/07/2021.
//

import SwiftUI
import Combine
import CoreData
import Foundation

struct HoursView: View {
    
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(entity: DrawingCanvas.entity(), sortDescriptors: []) var drawings: FetchedResults<DrawingCanvas>

   
    @Binding var ArrayHourUUID: [UUID]
    var ShowTime: String
    @State private var test = false
    
    @EnvironmentObject var hourOfDay: HourOfDay
    
    
    let fileManager = FileManager.default
    let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    @State var AddedNewCanvas: Bool = false
    @Binding var RefreshList: Bool
    
    @State var currentUUID: UUID? = UUID()
    @State var currentTitle: String = "NOT LOADED"
    @State var currentData: Data?
    @State var currentTask: String = "NO DESCRIPTION"
    
    var body: some View {
        ZStack {
            GeometryReader { bounds in
                ScrollView(.horizontal) {
                    LazyHStack {
                        Text(ShowTime)
                        ForEach(drawings, id: \.self){drawing in
                           EnumeratedForEach(ArrayHourUUID) { index, TimeUUID in
                                if !ArrayHourUUID.isEmpty {
                                        
                                        
                                        if TimeUUID == drawing.id {
                                            
                                            
                                            switch(drawing.typeRem) {
                                                case TypeReminder.drawing.rawValue:
                                                    LazyHStack (){
                                                
                                                
                                                
                                                    Button(action: {
                                                        fetchProperties(canvasUUID: drawing.id ?? UUID(), index: index);
                                                        test.toggle();
                                                        print("Keyboard shortcut pressed");
                                                    }) {
                                                        if getWallpaperFromUserDefaults() != nil {
                                                            Image(uiImage: fetchImage(imageName: String("\(drawing.id)")) ?? UIImage(data: getWallpaperFromUserDefaults()!)! ).resizable().scaledToFit().frame(width: 150, height: 150)
                                                                .keyboardShortcut("l", modifiers: .command)

                                                        
                                                    }
                                                        Text("Drawing \(drawing.title ?? "NO TITLE")")
                                                       

                                                    }
                                                        .sheet(isPresented: self.$test) {
                                                            DrawingView(isVisible: $test, id: currentUUID ?? UUID(), data: currentData, title: currentTitle)
                                                                .onDisappear() { print("DISMISS"); RefreshList.toggle()}
                                                            
                                                        }
                                                        
                                                    
                        //                            Text("\(drawing.timeEvent ?? Date())")

                                                }
                                                .contextMenu { Button(action: {
                                                        viewContext.delete(drawing)
                                                        deleteImage(imageName: String("\(drawing.id)"))
                                                        do {
                                                            try self.viewContext.save()
                                                            print("DELETED ITEM")
                                                        } catch {
                                                            print(error)
                                                        }
                                                    }) {
                                                        Text("Delete me")
                                                    }
                                                    
                                                }
                                                
                                                
                                                case TypeReminder.typed.rawValue:
                                                TypeReminderView(title: drawing.title ?? "NO TITLE", text: drawing.taskDescription ?? "NO DESCRIPTION", remUUID: drawing.id ?? UUID()) .contextMenu { Button(action:{
                                                    viewContext.delete(drawing)
                                                    do {
                                                        try self.viewContext.save()
                                                        print("DELETED ITEM")
                                                    } catch {
                                                        print(error)
                                                    }
                                                }) {
                                                    Text("Delete me")
                                                }}
                                                
//                                                    .onAppear(perform: {currentTitle = drawing.title ?? "NO TITLE"; currentTask = drawing.taskDescription ?? "NO DESCRIPTION"})
                                                
                                                case TypeReminder.image.rawValue:
                                                ImageReminderView(title: drawing.title ?? "NO TITLE", remUUID: drawing.id ?? UUID()).contextMenu { Button(action:{
                                                    viewContext.delete(drawing)
                                                    deleteImage(imageName: String("\(drawing.id)"))
                                                    do {
                                                        try self.viewContext.save()
                                                        print("DELETED ITEM")
                                                    } catch {
                                                        print(error)
                                                    }
                                                }) {
                                                    Text("Delete me")
                                                }}
                                                //MARK: To be implemented
                                                case TypeReminder.audio.rawValue:
                                                AudioPlayerView(title: drawing.title ?? "NO TITLE", remUUID: drawing.id ?? UUID(), audioURL: drawing.audioREMurl ?? "NO URL").contextMenu { Button(action:{
                                                    viewContext.delete(drawing)
                                                    deleteAudio(audioURL: drawing.audioREMurl ?? "NO URL")
                                                    do {
                                                        try self.viewContext.save()
                                                        print("DELETED ITEM")
                                                    } catch {
                                                        print(error)
                                                    }
                                                }) {
                                                    Text("Delete me")
                                                }}
                                                
                                                default:
                                                    Text("Other type")
                                                
                                            }
                                
                                            
                                            
                                    
                                    }
                                   
                                }

                                
                                   
                            }
                            
                            
                            
                            }
                            
                            .onDelete(perform: deleteItem)
                            
                            //.foregroundColor(.blue)
                            
                    }
                    
                }.frame(height: 200)
                
                Divider()
            }
        }
            

        
    }
    func deleteItem(at offset: IndexSet) {
        for index in offset{
            let itemToDelete = drawings[index]
            viewContext.delete(itemToDelete)
            deleteImage(imageName: String("\(drawings[index].id)"))
            do{
                try viewContext.save()
                print("DELETED ITEM")
            }
            catch{
                print(error)
            }
        }
    }
    
    // MARK: ERROR Handling in case of there is something loading the file, it will show the signature given by the user hwne signing the terms and conditions
    func getWallpaperFromUserDefaults() -> Data? {
      let defaults = UserDefaults.standard
        return defaults.object(forKey: "signatureImage") as? Data
    }
    
    // MARK: FETCH THE IMAGE FROM STORAGE
    func fetchImage(imageName: String) -> UIImage? { //Fetches images from the UUID of the canvas and returns a UIImage to be handled approprialy
        let imagePath = documentsPath.appendingPathComponent(imageName).path
        
        guard fileManager.fileExists(atPath: imagePath) else {
            print("Image does not exist at path: \(imagePath)")
            
            return nil
        }
        
        if let imageData = UIImage(contentsOfFile: imagePath) {
            return imageData
        } else {
            print("UIImage could not be created.")
            
            return nil
        }
    }
    
    
    //MARK: DELETE THE IMAGE FROM STORAGE
    
    
    func deleteImage(imageName: String) {
        let imagePath = documentsPath.appendingPathComponent(imageName)
        
        guard fileManager.fileExists(atPath: imagePath.path) else {
            print("Image does not exist at path: \(imagePath)")
            
            return
        }
        
        do {
            try fileManager.removeItem(at: imagePath)
            
            print("\(imageName) was deleted.")
        } catch let error as NSError {
            print("Could not delete \(imageName): \(error)")
        }
    }
    
    
    func fetchInitialProperties() {
        for drawing in drawings {
            for ArrayHourUUID in ArrayHourUUID {
                if ArrayHourUUID == drawing.id {
                    currentUUID = drawing.id!
                    currentTitle = drawing.title!
                    currentData = drawing.canvasData
                }
            }

        }
    }
    
    
    func fetchProperties(canvasUUID: UUID?, index: Int) {
        for drawing in drawings {
                if ArrayHourUUID[index] == drawing.id {
                    currentUUID = ArrayHourUUID[index]
                    currentTitle = drawing.title!
                    currentData = drawing.canvasData
                } else {
                    print("THERE ARE NO RECORD")
                }
        }
            }
    
    
    func deleteAudio(audioURL: String) {
        let audioPath = documentsPath.appendingPathComponent(audioURL)
        
        
        
        guard fileManager.fileExists(atPath: audioPath.path) else {
            print("Audio does not exist at path: \(String(describing: audioPath))")
            return
        }
        
        do {
            try fileManager.removeItem(at: audioPath)
            print("\(String(describing: audioPath)) was deleted")
        } catch let error as NSError {
            print("Could not delete \(String(describing: audioPath)): \(error)")
        }
    }
        
    }
    
    
//struct HoursView_Previews: PreviewProvider {
//    static var previews: some View {
//        HoursView()
//    }
//}

