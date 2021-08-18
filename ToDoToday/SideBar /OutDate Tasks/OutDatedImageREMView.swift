//
//  OutDatedImageREMView.swift
//  ToDoToday
//
//  Created by Noe De La Croix on 18/08/2021.
//

import SwiftUI

struct OutDatedImageREMView: View {
    
    let title: String
    let dateOverDue: Date
    let width: CGFloat
    let id: UUID
    
    let fileManager = FileManager.default
    let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    
    @State private var isPresented = false
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text(title)
                    Divider()
                    Text("Was due on \(dateOverDue.toString(dateFormat: "MMM d, hha"))")
                }.frame(height: 30)
                
                
                
                Button(action: {isPresented.toggle()}, label: {Image(uiImage: fetchImage(imageName: String("\(id)")) ?? UIImage(data: getWallpaperFromUserDefaults()!)! ).resizable().scaledToFit().frame(width: width * 0.8, height: 120)}).fullScreenCover(isPresented: $isPresented, content: {
                    VStack {
                        Image(uiImage: fetchImage(imageName: String("\(id)")) ?? UIImage(data: getWallpaperFromUserDefaults()!)! ).resizable().scaledToFit()
                        
                        
                        HStack {
                            Spacer()
                            Button(action: {isPresented.toggle()}) {
                                Text("Dismiss me")
                                
                            }.padding(.trailing, 40)
                        }.frame(height: 30, alignment: .bottomTrailing)
                    }
                    
                })
                
            }.padding()
            .background(RoundedRectangle(cornerRadius: 12).foregroundColor(.white))
            .clipped()
            
          
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
    
    // MARK: ERROR Handling in case of there is something loading the file, it will show the signature given by the user hwne signing the terms and conditions
    func getWallpaperFromUserDefaults() -> Data? {
      let defaults = UserDefaults.standard
        return defaults.object(forKey: "signatureImage") as? Data
    }
    
    
}

//struct OutDatedImageREMView_Previews: PreviewProvider {
//    static var previews: some View {
//        OutDatedImageREMView()
//    }
//}
