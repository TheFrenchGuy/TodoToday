//
//  DrawingCanvasView.swift
//  ToDoToday
//
//  Created by Noe De La Croix on 21/07/2021.
//

import SwiftUI
import CoreData
import PencilKit

struct DrawingCanvasView: UIViewControllerRepresentable {
    @Environment(\.managedObjectContext) private var viewContext
    
    // Necassary to store the image on device storage
    
    let fileManager = FileManager.default
    let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    // UIKIT
    
    func updateUIViewController(_ uiViewController: DrawingCanvasViewController,context: Context) {
        uiViewController.drawingData = data
    }
    typealias UIViewControllerType = DrawingCanvasViewController //Refers to the UIViewRepresnetable code
    
    
    
    var data: Data
    var id: UUID
    
    func makeUIViewController(context: Context) -> DrawingCanvasViewController {
        let viewController = DrawingCanvasViewController()
        viewController.drawingData = data
        viewController.drawingChanged = {data in
            let request: NSFetchRequest<DrawingCanvas> = DrawingCanvas.fetchRequest()
            let predicate = NSPredicate(format: "id == %@", id as CVarArg)
            request.predicate = predicate
            do{
                let result = try viewContext.fetch(request)
                let obj = result.first
                obj?.setValue(data, forKey: "canvasData")
                do{
                    SaveSignature()
                    try viewContext.save() //Save the canvas to the stack each time a new upadte is made
                }
                catch{
                    print(error)
                }
            }
            catch{
                print(error)
            }
        }
        
        func SaveSignature() {
            let image = viewController.canvas.drawing.image(from: viewController.canvas.drawing.bounds, scale: 1)
            //let imageData = image.jpegData(compressionQuality: 1.0)
            print("Image saved as name: \(saveImage(image: image) ?? "IMAGE SAVING ERRROR")") //DEBUG ONLY SINCE IT IS ALREADY PRINTED TO THE CONSOLE WHILE RUING THE FUNCTION
            
            
        }
        
        return viewController
        
        
        
    }
    
    
    
    
   
    
  //MARK: Save the Canvas as an UIImage
    func saveImage(image: UIImage) -> String? {
//        let date = String( Date.timeIntervalSinceReferenceDate )
//        let imageName = date.replacingOccurrences(of: ".", with: "-") + ".png"
        let imageName = String("Optional(\(id))") // So that will use the UUID from the drawing canvas and name it as its file name, so the file can later just be looked up as the UUID of the canvas and does not need to store an extra propery in coredata.
        ///AKA could not figure out how to implement the coredata stack in the view and store a propery there.
        
        if let imageData = image.pngData() {
            do {
                let filePath = documentsPath.appendingPathComponent(imageName)
                
                try imageData.write(to: filePath)
                
                print("\(imageName) was saved.")
                
                return imageName
            } catch let error as NSError {
                print("\(imageName) could not be saved: \(error)")
                
                return nil
            }
            
        } else {
            print("Could not convert UIImage to png data.")
            
            return nil
        }
    }

}


