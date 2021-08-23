//
//  DrawingReminderView.swift
//  ToDoToday
//
//  Created by Noe De La Croix on 23/08/2021.
//

import SwiftUI

struct DrawingReminderView: View {
    var title: String
    var remUUID: UUID
    var tabColor: UIColor
    var remData: Data
    
    var startTime:Date
    var endTime: Date
    var height: CGFloat
    var heightTime: CGFloat
    
    
    let fileManager = FileManager.default
    let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    
    
    @State private var test = false
    @Binding var refreshList: Bool
    
    
    var body: some View {
        ZStack{
        VStack() {
            
            RoundedRectangle(cornerRadius: 6).foregroundColor(Color(tabColor)).frame(height: height / 15)
                
            LazyHStack (){
        
        
        
            Button(action: {
                test.toggle();
                print("Keyboard shortcut pressed");
            }) {
                if getWallpaperFromUserDefaults() != nil {
                    Image(uiImage: fetchImage(imageName: String("\(remUUID)")) ?? UIImage(data: getWallpaperFromUserDefaults()!)! ).resizable().scaledToFit().frame(width: 150, height: heightTime - 20)
                        .keyboardShortcut("l", modifiers: .command)

                
            }
              //  Text("Drawing \(drawing.title ?? "NO TITLE")")
               

            }
                .sheet(isPresented: self.$test) {
                    DrawingView(isVisible: $test, id: remUUID, data: remData, title: title, startTime: startTime)
                        .onDisappear() { print("DISMISS"); refreshList.toggle()}
                    
                }
                
            
//                            Text("\(drawing.timeEvent ?? Date())")
               
            }
            
        }.background(RoundedRectangle(cornerRadius: 6).foregroundColor(Color(tabColor).opacity(0.6)))
        
            
//                                                   Circle().fill(Color(drawing.tabColor?.uiColor ?? .red))
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
    
}

//struct DrawingReminderView_Previews: PreviewProvider {
//    static var previews: some View {
//        DrawingReminderView()
//    }
//}
