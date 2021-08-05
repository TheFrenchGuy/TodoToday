//
//  ImageReminderView.swift
//  ToDoToday
//
//  Created by Noe De La Croix on 30/07/2021.
//

import SwiftUI

struct ImageReminderView: View {
    var title: String
    var remUUID: UUID
    var tabColor: UIColor
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(entity: DrawingCanvas.entity(), sortDescriptors: []) var drawings: FetchedResults<DrawingCanvas>
    
    @State private var updatedTask = updatedTaskDesClass()
    
    let fileManager = FileManager.default
    let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    @State var showSheet: Bool = false
    
    var body: some View {
        VStack {
            
            Button(action: {showSheet.toggle()}) {
                Text(title)
                if getWallpaperFromUserDefaults() != nil {
                    Image(uiImage: fetchImage(imageName: String("\(updatedTask.newTaskUUID)")) ?? UIImage(data: getWallpaperFromUserDefaults()!)! ).resizable().scaledToFit().frame(width: 150, height: 150)
                        .keyboardShortcut("l", modifiers: .command)

                
                }
                Circle().fill(Color(tabColor))
            }.sheet(isPresented: $showSheet) {
                Image(uiImage: fetchImage(imageName: String("\(updatedTask.newTaskUUID)")) ?? UIImage(data: getWallpaperFromUserDefaults()!)! ).resizable().scaledToFit().frame(width: 150, height: 150)
                    .keyboardShortcut("l", modifiers: .command)
            }
        }.onAppear(perform: {updatedTask.newTaskUUID = remUUID; updatedTask.newTaskTitle = title})
        
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
    
    // MARK: ERROR Handling in case of there is something loading the file, it will show the signature given by the user hwne signing the terms and conditions
    func getWallpaperFromUserDefaults() -> Data? {
      let defaults = UserDefaults.standard
        return defaults.object(forKey: "signatureImage") as? Data
    }
    
    
}

//struct ImageReminderView_Previews: PreviewProvider {
//    static var previews: some View {
//        ImageReminderView()
//    }
//}
