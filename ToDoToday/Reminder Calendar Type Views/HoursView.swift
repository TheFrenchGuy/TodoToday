//
//  HoursView.swift
//  ToDoToday
//
//  Created by Noe De La Croix on 23/07/2021.
//

import SwiftUI

struct HoursView: View {
    
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(entity: DrawingCanvas.entity(), sortDescriptors: []) var drawings: FetchedResults<DrawingCanvas>

    @State private var showSheet = false
   
    @Binding var ArrayHourUUID: [UUID]
    var ShowTime: String
    @State private var test = false
    
    let fileManager = FileManager.default
    let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    @State var AddedNewCanvas: Bool = false
    @Binding var RefreshList: Bool
    var body: some View {
        GeometryReader { bounds in
            HStack {
                
                    Text(ShowTime)
                    ForEach(drawings){drawing in
                        if !ArrayHourUUID.isEmpty {
                            ForEach(ArrayHourUUID, id: \.self) { TimeUUID in
                                
                                if TimeUUID == drawing.id {
                        
                            HStack () {
                                
                                
                                

                                Button(action: { test.toggle(); print("Keyboard shortcut pressed")}) {
    //                                Text("Tap here").keyboardShortcut("l", modifiers: .command)
                                    if getWallpaperFromUserDefaults() != nil {
                                        Image(uiImage: fetchImage(imageName: String("\(drawing.id)")) ?? UIImage(data: getWallpaperFromUserDefaults()!)! ).resizable().scaledToFit().frame(width: 150, height: 150)
                                            .keyboardShortcut("l", modifiers: .command)

                                    
                                }
                                    Text("Drawing \(drawing.title ?? "NO TITLE")")
                                   

                                    }
                                    .sheet(isPresented: self.$test) {
                                        DrawingView(isVisible: $test, id: drawing.id, data: drawing.canvasData, title: drawing.title).onDisappear() { print("DISMISS"); RefreshList.toggle()}
                                    }
                                
    //                            Text("\(drawing.timeEvent ?? Date())")

                            }.contextMenu { Button(action: {
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
                            }
                            }
                        }

                    }
                    .onDelete(perform: deleteItem)

                    .foregroundColor(.blue)
                    .sheet(isPresented: $showSheet, content: {
                        AddNewCanvasView(AddedNewCanvas: $AddedNewCanvas).environment(\.managedObjectContext, viewContext)
                    })
                
            }.frame(height: 200)
            Divider()
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
    
    
    
}

//struct HoursView_Previews: PreviewProvider {
//    static var previews: some View {
//        HoursView()
//    }
//}
