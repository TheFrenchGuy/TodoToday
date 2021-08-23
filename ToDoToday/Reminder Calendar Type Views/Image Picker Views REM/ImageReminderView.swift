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
    var windowSize:CGSize
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 6).foregroundColor(Color(tabColor)).frame(height: windowSize.height / 15)
            
            Button(action: {showSheet.toggle()}, label: {
               // Text(title)
                if getWallpaperFromUserDefaults() != nil {
                    Image(uiImage: fetchImage(imageName: String("\(updatedTask.newTaskUUID)")) ?? UIImage(data: getWallpaperFromUserDefaults()!)! ).resizable().scaledToFit().frame(width: 150, height: 150)
                        .keyboardShortcut("l", modifiers: .command)

                
                }
               
            }).fullScreenCover(isPresented: $showSheet, content:  {
                
                VStack {
                    Image(uiImage: fetchImage(imageName: String("\(updatedTask.newTaskUUID)")) ?? UIImage(data: getWallpaperFromUserDefaults()!)! ).resizable().scaledToFit()
                    
                    HStack {
                        Spacer()
                        Button(action: {showSheet.toggle()}) {
                            Text("Dismiss me")
                            
                        }.padding(.trailing, 40)
                    }.frame(height: 30, alignment: .bottomTrailing)
                }
                
            })
        }.onAppear(perform: {updatedTask.newTaskUUID = remUUID; updatedTask.newTaskTitle = title})
         .background(RoundedRectangle(cornerRadius: 6).foregroundColor(Color(tabColor).opacity(0.6)))
        
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
