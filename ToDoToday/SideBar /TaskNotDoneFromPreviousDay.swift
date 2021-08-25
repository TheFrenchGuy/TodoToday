//
//  TaskNotDoneFromPreviousDay.swift
//  ToDoToday
//
//  Created by Noe De La Croix on 17/08/2021.
//

import SwiftUI

struct TaskNotDoneFromPreviousDayView: View {
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(entity: DrawingCanvas.entity(), sortDescriptors: []) var drawings: FetchedResults<DrawingCanvas>
    
    let fileManager = FileManager.default
    let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    
    var body: some View {
        
        ZStack {
            
            GeometryReader { bounds in
                VStack(alignment: .center) {
                    
                    Text("Overdue tasks").font(.largeTitle).bold().padding(.leading, 10).frame(width: bounds.size.width, alignment: .leading)
                    
                    ScrollView(.vertical) {
                        ForEach(drawings, id: \.self) {drawing in
                            
                            if checkIfOverDue(dueTime: drawing.endTime ?? Date(), isCompleted: drawing.completedTask) {
                                if drawing.typeRem ==  TypeReminder.drawing.rawValue{
                                    HStack {
                                        if getWallpaperFromUserDefaults() != nil {
                                            
                                            VStack {
                                                HStack {
                                                    Text(drawing.title ?? "No title")
                                                    Divider()
                                                    Text("Was due on \((drawing.endTime?.toString(dateFormat: "MMM d, hha "))!)")
                                                }.frame(height: 30)
                                                Image(uiImage: fetchImage(imageName: String("\(drawing.id)")) ?? UIImage(data: getWallpaperFromUserDefaults()!)! ).resizable().scaledToFit().frame(width: bounds.size.width * 0.8, height: 120)
                                            }.padding()
                                            .background(RoundedRectangle(cornerRadius: 12).foregroundColor(.white))
                                            .clipped()
                                        }
                                        
                                        
                                    }.contextMenu(ContextMenu(menuItems: {
                                        Button(action: {
                                            markTaskAsDone(id: drawing.id ?? UUID())
                                        }) {
                                            Text("Mark me as complete")
                                        }
                                        
                                        
                                        Button(action: {
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
                                        
                                        
                                    }))
                                }
                                
                                 if drawing.typeRem == TypeReminder.typed.rawValue {
                                    OutDatedTypedREMView(title: drawing.title ?? "NO TITLE", description: drawing.taskDescription ?? "NO DESCRIPTION" , dateOverDue: drawing.endTime ?? Date(), width: bounds.size.width)
                                        .contextMenu(ContextMenu(menuItems: {
                                            Button(action: {
                                                markTaskAsDone(id: drawing.id ?? UUID())
                                            }) {
                                                Text("Mark me as complete")
                                            }
                                            
                                            
                                            Button(action: {
                                                    viewContext.delete(drawing)
                                                    do {
                                                        try self.viewContext.save()
                                                        print("DELETED ITEM")
                                                    } catch {
                                                        print(error)
                                                    }
                                                }) {
                                                    Text("Delete me")
                                                }
                                            
                                            
                                        }))
                                }
                                 if drawing.typeRem == TypeReminder.image.rawValue {
                                    OutDatedImageREMView(title: drawing.title ?? "NO TITLE", dateOverDue: drawing.endTime ?? Date(), width: bounds.size.width, id: drawing.id ?? UUID())
                                    
                                        .contextMenu(ContextMenu(menuItems: {
                                            Button(action: {
                                                markTaskAsDone(id: drawing.id ?? UUID())
                                            }) {
                                                Text("Mark me as complete")
                                            }
                                            
                                            
                                            Button(action: {
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
                                            
                                            
                                        }))
                                }
                                 if drawing.typeRem == TypeReminder.audio.rawValue {
                                    OutDatedAudioREMView(audioURL: drawing.audioREMurl ?? "NO audio URL", title: drawing.title ?? "NO TITLE", dateOverDue: drawing.endTime ?? Date(), width: bounds.size.width)
                                    
                                        .contextMenu(ContextMenu(menuItems: {
                                            Button(action: {
                                                markTaskAsDone(id: drawing.id ?? UUID())
                                            }) {
                                                Text("Mark me as complete")
                                            }
                                            
                                            
                                            Button(action: {
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
                                                }
                                            
                                            
                                        }))
                                }
                            }
                        }
                    }
                    
                    Spacer()
                }
            }
        }
    }
    
    func checkIfOverDue(dueTime: Date, isCompleted: Bool) -> Bool  {
        var isOverDue: Bool = true
        
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        let todayDate = formatter.string(from: Date())
        let dueDate = formatter.string(from: dueTime)
        print("Today Date: \(todayDate) + \(dueDate)")
        
        
        if todayDate == dueDate{
            isOverDue = false
        }
        
        
        
//        if timediff > 86400 && timediff < 172800 && !isCompleted {
//            isOverDue = true
//        }
        return isOverDue
        
    }
    
    
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
    
    
    func markTaskAsDone(id: UUID) {
        for drawing in drawings {
            if drawing.id == id {
                drawing.completedTask = true
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

//struct TaskNotDoneFromPreviousDay_Previews: PreviewProvider {
//    static var previews: some View {
//        TaskNotDoneFromPreviousDay()
//    }
//}
