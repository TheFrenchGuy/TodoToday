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

    @State private var test = false
    
    @EnvironmentObject var hourOfDay: HourOfDay
    
    
    let fileManager = FileManager.default
    let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    @State var AddedNewCanvas: Bool = false
    @Binding var RefreshList: Bool
    
    var TimeUUID: UUID
    
    @State var currentUUID: UUID? = UUID()
    @State var currentTitle: String = "NOT LOADED"
    @State var currentData: Data?
    @State var currentTask: String = "NO DESCRIPTION"
    @State var currentCalendar: String = "NO CALENDAR"
    
    @EnvironmentObject var transferColorPalette:TransferColorPalette
    @EnvironmentObject var refreshListClass:RefreshListClass
    @EnvironmentObject var taskPerHour:TaskPerHour
    @EnvironmentObject var tabViewClass: TabViewClass
    
    
    @StateObject var showActivitySelector = showActivityShareSelector()
    @State var sendToShareAll: Bool = false
    
     var heightTime: CGFloat
    
    
    
    
    var body: some View {
        ZStack {
            GeometryReader { bounds in
                ZStack {
                    LazyHStack {
                        ForEach(drawings, id: \.self){drawing in
                               
                               if shouldShowBasedOnCalendar(calendarName: drawing.calendarNameAdded ?? "No CALENDAR STORED") {
                                        
                                        
                                    if TimeUUID == drawing.id {
                                        ZStack() {
                                            switch(drawing.typeRem) {
                                                case TypeReminder.drawing.rawValue:
                                                ZStack {
                                                VStack() {
                                                    
                                                    RoundedRectangle(cornerRadius: 6).foregroundColor(Color(drawing.tabColor?.uiColor ?? .red)).frame(height: 7)
                                                        
                                                    LazyHStack (){
                                                
                                                
                                                
                                                    Button(action: {
                                                        fetchProperties(canvasUUID: drawing.id ?? TimeUUID);
                                                        
                                                        tabViewClass.editTask.toggle()
                                                        tabViewClass.editTaskUUID = drawing.id ?? TimeUUID
                                                        tabViewClass.taskType = TypeReminder.drawing.rawValue
//                                                        test.toggle();
                                                        print("Keyboard shortcut pressed");
                                                    }) {
//                                                        if getWallpaperFromUserDefaults() != nil {
//                                                            Image(uiImage: fetchImage(imageName: String("\(drawing.id)")) ?? UIImage(data: getWallpaperFromUserDefaults()!)! ).resizable().scaledToFit().frame(width: 150, height: heightTime - 20)
//                                                                .keyboardShortcut("l", modifiers: .command)
//
//
//                                                    }
                                                        
                                                        Image(uiImage: UIImage.init(data: drawing.imageData ?? Data()) ?? UIImage()).resizable().scaledToFit().frame(width: 300, height: heightTime - 20)
                                                      //  Text("Drawing \(drawing.title ?? "NO TITLE")")
                                                       

                                                    }
//                                                        .sheet(isPresented: self.$test) {
//                                                            DrawingView(isVisible: $test, id: currentUUID ?? UUID(), data: currentData, title: currentTitle, startTime: drawing.startTime ?? Date(), endTime: drawing.endTime ?? Date()) .environment(\.managedObjectContext, viewContext) // Fixed the error that came saying there is no coordinate store attached to it
//                                                                .onDisappear() { print("DISMISS"); RefreshList.toggle()}
//
//                                                        }
                                                        
                                                    
                        //                            Text("\(drawing.timeEvent ?? Date())")
                                                       
                                                    }
                                                    
                                                }.background(RoundedRectangle(cornerRadius: 6).foregroundColor(Color(drawing.tabColor?.uiColor ?? .red).opacity(0.6)))
                                                
                                                .sheet(isPresented: $sendToShareAll, content: { ShareREMAll(imageData: drawing.imageData! )})
//                                                   Circle().fill(Color(drawing.tabColor?.uiColor ?? .red))
                                                }
                                                
                                                    
                                                
                                                
                                                
                                                
                                                case TypeReminder.typed.rawValue:
                                                TypeReminderView(title: drawing.title ?? "NO TITLE", text: drawing.taskDescription ?? "NO DESCRIPTION", remUUID: drawing.id ?? UUID(), tabColor: drawing.tabColor?.uiColor ?? .red, completedTask: drawing.completedTask,startTime: drawing.startTime ?? Date(),endTime: drawing.endTime ?? Date(), heightTime: heightTime, windowSize: bounds.size).sheet(isPresented: $sendToShareAll, content: { ShareREMAll(title: drawing.title ?? "NO title", taskDesc: drawing.taskDescription ?? "NO TaskDesc")})
//                                                    .contextMenu { Button(action:{
//                                                    viewContext.delete(drawing)
//                                                    do {
//                                                        try self.viewContext.save()
//                                                        print("DELETED ITEM")
//                                                    } catch {
//                                                        print(error)
//                                                    }
//                                                    RefreshList.toggle()
//                                                }) {
//                                                    Text("Delete me")
//                                                }
//
////                                                    Button(action: {
////                                                        showActivitySelector.text = true
////                                                        sendToShareAll = true
////                                                    }) {
////
////                                                        HStack {
////                                                            Image(systemName: "square.and.arrow.up")
////                                                            Text("Share it")
////                                                        }
////                                                    }
//                                                }
                                                    
                                                
                                                
//                                                    .onAppear(perform: {currentTitle = drawing.title ?? "NO TITLE"; currentTask = drawing.taskDescription ?? "NO DESCRIPTION"})
                                                
                                                case TypeReminder.image.rawValue:
                                                    ImageReminderView(title: drawing.title ?? "NO TITLE", remUUID: drawing.id ?? UUID(), tabColor: drawing.tabColor?.uiColor ?? .red,imageData: drawing.imageData ?? Data(),heightTime: heightTime,startTime: drawing.startTime ?? Date(), endTime: drawing.endTime ?? Date(), windowSize: bounds.size)
                                                        .sheet(isPresented: $sendToShareAll, content: { ShareREMAll(imageData: drawing.imageData ?? Data())})
//                                                        .contextMenu { Button(action:{
//                                                        viewContext.delete(drawing)
//                                                        deleteImage(imageName: String("\(drawing.id)"))
//                                                        do {
//                                                            try self.viewContext.save()
//                                                            print("DELETED ITEM")
//                                                        } catch {
//                                                            print(error)
//                                                        }
//                                                        RefreshList.toggle()
//                                                    }) {
//                                                        Text("Delete me")
//                                                    }
//
////                                                    Button(action: {
////                                                        showActivitySelector.image = true
////                                                        sendToShareAll = true
////                                                    }) {
////
////                                                        HStack {
////                                                            Image(systemName: "square.and.arrow.up")
////                                                            Text("Share it")
////                                                        }
////                                                    }
//                                                }
                                                    
                                                   
                                                case TypeReminder.audio.rawValue:
                                                    AudioPlayerView(title: drawing.title ?? "NO TITLE", remUUID: drawing.id ?? UUID(), audioURL: drawing.audioREMurl ?? "NO URL",audioData: drawing.audioData ?? Data(), tabColor: drawing.tabColor?.uiColor ?? .red, completedTask: drawing.completedTask, windowSize: bounds.size, heightTime: heightTime).sheet(isPresented: $sendToShareAll, content: { ShareREMAll( audioURL: drawing.audioREMurl ?? "NO URL")})
//                                                    .contextMenu { Button(action:{
//                                                    viewContext.delete(drawing)
//                                                    deleteAudio(audioURL: drawing.audioREMurl ?? "NO URL")
//                                                    do {
//                                                        try self.viewContext.save()
//                                                        print("DELETED ITEM")
//
//                                                    } catch {
//                                                        print(error)
//                                                    }
//                                                    RefreshList.toggle()
//                                                }) {
//                                                    Text("Delete me")
//                                                }}
                                                
                                                default:
                                                    Text("Other type")
                                                        .sheet(isPresented: $sendToShareAll, content: { ShareREMAll()})
//                                                        .contextMenu { Button(action:{
//                                                            viewContext.delete(drawing)
//                                                            deleteImage(imageName: String("\(drawing.id)"))
//                                                            do {
//                                                                try self.viewContext.save()
//                                                                print("DELETED ITEM")
//                                                            } catch {
//                                                                print(error)
//                                                            }
//                                                            RefreshList.toggle()
//                                                        }) {
//                                                            Text("Delete me")
//                                                        }
//                                                    }
                                                    
                                                        
                                                
                                            }
                                    }.contextMenu { Button(action: {
                                        viewContext.delete(drawing)
                                        deleteImage(imageName: String("\(drawing.id)"))
                                        
                                        
                                        
                                        deleteAudio(audioURL: drawing.audioREMurl ?? "NO URL")
                                        do {
                                            try self.viewContext.save()
                                            print("DELETED ITEM")
                                        } catch {
                                            print(error)
                                        }
                                        RefreshList.toggle()
                                    }) {
                                        HStack {
                                            Image(systemName: "trash")
                                            Text("Delete me")
                                        }.foregroundColor(.red)
                                    }
                                
                                        Button(action: {
                                            switch(drawing.typeRem) {
                                                case TypeReminder.drawing.rawValue:
                                                    showActivitySelector.drawing = true
                                                
                                                case TypeReminder.typed.rawValue :
                                                    showActivitySelector.text = true
                                                case TypeReminder.image.rawValue:
                                                    showActivitySelector.image = true
                                                case TypeReminder.audio.rawValue:
                                                    showActivitySelector.audio = true
                                                    
                                                default:
                                                    showActivitySelector.text = true
                                            }
                                            sendToShareAll = true
                                        }) {

                                            HStack {
                                                Image(systemName: "square.and.arrow.up")
                                                Text("Share it")
                                            }
                                        }
                                        
                                        Button(action: {
                                            drawing.completedTask.toggle()
                                            do {
                                                try self.viewContext.save()
                                                print("Completed item")
                                            } catch {
                                                print(error)
                                            }
                                            
                                            RefreshList.toggle()
                                        }) {
                                            
                                            if drawing.completedTask {
                                                HStack {
                                                    Image(systemName: "studentdesk")
                                                    Text("Wasn't finished")
                                                }
                                            } else {
                                                HStack {
                                                    Image(systemName: "studentdesk")
                                                    Text("Completed")
                                                }
                                            }
                                        }
                                        
                                        
                                    }
                                
                                            
                                            
                                    
                                    }
                                   
                                }
                               

                                
                                   
                            
                            
                            
                            
                            }
                            
                            
                            .onDelete(perform: deleteItem)
                        
                            
                            
                            //.foregroundColor(.blue)
                            
                    }
                    
                }.frame(height: heightTime)
                .onAppear(perform: {fetchInitialProperties()})
                
                
            }
        }.environmentObject(showActivitySelector)
            

        
    }
    
    func shouldShowBasedOnCalendar(calendarName: String) -> Bool {
        var isMarked = false
        for transfer in transferColorPalette.colorpla {
            if transfer.title == calendarName && transfer.isMarked{
                //print("Calendar name match")
                isMarked = true
               
            }
            
        }
        
        return isMarked
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
           
                if TimeUUID == drawing.id {
                    currentUUID = drawing.id!
                    currentTitle = drawing.title!
                    currentData = drawing.canvasData
                    currentCalendar = drawing.calendarNameAdded ?? "No name"
                }
            

        }
    }
    
    
    func fetchProperties(canvasUUID: UUID?) {
        for drawing in drawings {
                if TimeUUID == drawing.id {
                    currentUUID = TimeUUID
                    currentTitle = drawing.title!
                    currentData = drawing.canvasData
                } else {
                    print("THERE ARE NO RECORD")
                }
        }
            }
    
    
    func deleteAudio(audioURL: String) {
//        let docPath = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents")
//        let audioPath = docPath!.appendingPathComponent(audioURL)
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

