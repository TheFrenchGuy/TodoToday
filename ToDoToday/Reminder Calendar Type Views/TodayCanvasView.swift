//
//  TodayCanvasView.swift
//  ToDoToday
//
//  Created by Noe De La Croix on 21/07/2021.
//

import SwiftUI
import CoreData
import Combine


struct TodayCanvasView: View {
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(entity: DrawingCanvas.entity(), sortDescriptors: []) var drawings: FetchedResults<DrawingCanvas>
    
    @State private var showSheet = false
    @State private var test = false
    
    
    let fileManager = FileManager.default
    let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    

    var body: some View {
        ZStack {
            GeometryReader { bounds in
                VStack{
                        if drawings.count == 0 {
                            PlaceholderView()
                            
                            Button(action: {
                                self.showSheet.toggle()
                            }, label: {
                                HStack{
                                    Image(systemName: "plus")
                                    Text("Add Canvas")
                                }
                            })
                            .foregroundColor(.blue)
                            .sheet(isPresented: $showSheet, content: {
                                AddNewCanvasView().environment(\.managedObjectContext, viewContext)
                            })
                        } else {
                            
                            VStack {
                                Button(action: {
                                    self.showSheet.toggle()
                                }, label: {
                                    HStack{
                                        Image(systemName: "plus")
                                        Text("Add Canvas")
                                    }
                                })
                                .foregroundColor(.blue)
                                .sheet(isPresented: $showSheet, content: {
                                    AddNewCanvasView().environment(\.managedObjectContext, viewContext)
                                })
                                
                                
                                
                                List {
                                    ForEach(drawings){drawing in
                                        HStack () {
                                            if getWallpaperFromUserDefaults() != nil {
                                                Image(uiImage: fetchImage(imageName: String("\(drawing.id)")) ?? UIImage(data: getWallpaperFromUserDefaults()!)! ).resizable().scaledToFit().frame(width: 100, height: 100)
                            
                                            }
                            
                                            Button(action: { test.toggle(); print("Keyboard shortcut pressed")}) { Text("Tap here")}.keyboardShortcut("l", modifiers: .command)
                                            Text("Canvas, \(drawing.id ?? UUID()), \(drawing.title ?? "NO TITLE ")").sheet(isPresented: self.$test) {
                                                DrawingView(isVisible: $test, id: drawing.id, data: drawing.canvasData, title: drawing.title)
                                            }
                                            
                                        }.contextMenu { Button(action: {
                                            viewContext.delete(drawing)
                                            deleteImage(imageName: String("\(drawing.id)"))
                                            do {
                                                try self.viewContext.save()
                                            } catch {
                                                print(error)
                                            }
                                        }) {
                                            Text("Delete me")
                                        }}

                                        
                                    }
                                    .onDelete(perform: deleteItem)
                                    
                                    Button(action: {
                                        self.showSheet.toggle()
                                    }, label: {
                                        HStack{
                                            Image(systemName: "plus")
                                            Text("Add Canvas")
                                        }
                                    })
                                    .foregroundColor(.blue)
                                    .sheet(isPresented: $showSheet, content: {
                                        AddNewCanvasView().environment(\.managedObjectContext, viewContext)
                                    })
                                }

                                        }

                    
                    
                    
                }
                }.frame(width: bounds.size.width, height: bounds.size.height)
        }
        }
    
        
    }
    // MARK: ERROR Handling in case of there is something loading the file, it will show the signature given by the user hwne signing the terms and conditions
    func getWallpaperFromUserDefaults() -> Data? {
      let defaults = UserDefaults.standard
        return defaults.object(forKey: "signatureImage") as? Data
    }
    
    func deleteItem(at offset: IndexSet) {
        for index in offset{
            let itemToDelete = drawings[index]
            viewContext.delete(itemToDelete)
            deleteImage(imageName: String("\(drawings[index].id)"))
            do{
                try viewContext.save()
            }
            catch{
                print(error)
            }
        }
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


struct TodayCanvas_Previews: PreviewProvider {
    static var previews: some View {
        TodayCanvasView()
    }
}




