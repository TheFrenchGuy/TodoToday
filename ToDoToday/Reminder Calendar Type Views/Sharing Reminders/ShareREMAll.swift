//
//  ShareREMAll.swift
//  ToDoToday
//
//  Created by Noe De La Croix on 23/08/2021.
//

import SwiftUI

struct ShareREMAll: View {
    @EnvironmentObject var showActivityShare: showActivityShareSelector
    var imageName: UUID?
    var title: String?
    var taskDesc: String?
    var audioURL: String?
    
    let fileManager = FileManager.default
    let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    let data = Data()
    
    var body: some View {
        if showActivityShare.drawing == true  || showActivityShare.image == true{
            ActivityViewController(activityItems: [fetchImage(imageName: String("\(imageName)")) ?? UIImage(systemName: "xmark.octagon")!, "Shared to you by ToDoToday"])
            
        }
        
        if showActivityShare.text == true {
            ActivityViewController(activityItems: [title! ,taskDesc!, "Shared to you by ToDoToday"])
        }
        
        if showActivityShare.audio == true {
            ActivityViewController(activityItems: [ URL(fileURLWithPath: documentsPath.appendingPathComponent("\(audioURL!)").path), "Shared to you by ToDoToday"])
        }
        
        
    }
    
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
}

struct ShareREMAll_Previews: PreviewProvider {
    static var previews: some View {
        ShareREMAll()
    }
}


//ActivityViewController(activityItems: [fetchImage(imagName: String("\(drawing.id)"))!, "Shared to you by ToDoToday"])

//ActivityViewController(activityItems: [drawing.title, drawing.taskDescription, "Shared to you by ToDoToday"]
