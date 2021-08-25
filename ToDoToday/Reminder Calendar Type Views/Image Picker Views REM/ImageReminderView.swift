//
//  ImageReminderView.swift
//  ToDoToday
//
//  Created by Noe De La Croix on 30/07/2021.
//

import SwiftUI

struct ImageReminderView: View {
    @State var title: String = "NO TITLE"
    var remUUID: UUID
    var tabColor: UIColor
    @State var startTime: Date = Date()
    @State var endTime: Date = Date().addingTimeInterval(3600)
    
    @State var showSettings: Bool = false
    
    
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
                if !showSettings {
                    VStack {
                        Image(uiImage: fetchImage(imageName: String("\(updatedTask.newTaskUUID)")) ?? UIImage(data: getWallpaperFromUserDefaults()!)! ).resizable().scaledToFit()
                        
                        HStack {
                            
                            Button(action: {showSheet.toggle()}) {
                                Text("Dismiss me")
                                
                            }.padding(.leading, 50)
                            
                            
                            Spacer()
                            Button(action: {
                                withAnimation() {
                                    self.showSettings = true
                                    
                                }
                                
                            }) { Image(systemName: "slider.horizontal.3")}.padding(.trailing, 50)
                            
                            
                        }.frame(height: 50, alignment: .bottom)
                        
                        
                    }
                } else {
                    VStack(alignment: .leading) {
                        
                        Button(action: {
                            
                            withAnimation() {
                                self.showSettings = false
                            }
                        
                        }) {
                            HStack{
                                Image(systemName: "chevron.backward")
                                Text("Back to drawing")
                                Spacer()
                            }
                        }.padding()
                       // .padding(.bottom, 40)
                        
                        Text("What would you like to modifiy about your task?").font(.title2).bold().padding()
                        
                        
                        
                        Form {
                            
                            
                            Section(header: Text("Title")) {
                            
                            
                                VStack(alignment: .leading) {
                                    Text("Title of your task:")
                                    HStack() {
                                        Spacer()
                                        TextField("Title of Task", text: $title)
                                    }
                                }.padding()
                                
                            }
                            
                            
                            Section(header: Text("Timings")) {
                            
                                DatePicker("Start of Event", selection: $startTime).padding()
                                DatePicker("Completion Time of Event", selection: $endTime ).padding()
                            }
                            
                                                
                            Section(header: Text("Make sure you delayed the tasks being done")) {
                            Button(action: {
                                   updateFields()
                            }) {
                                HStack(alignment: .center) {
                                    Image(systemName: "externaldrive.badge.icloud")
                                    Text("Save update")
                                    
                                }
                            }.padding()
                                
                            }
                        }
                    }
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
    
    
    func updateFields() {
        for drawing in drawings {
            if drawing.id == remUUID {
                drawing.title = title
                drawing.startTime = startTime
                drawing.endTime = endTime
                
                do {
                    try viewContext.save()
                  //  try viewContext.refreshAllObjects()
                    print("Saved")
                    
                }
                catch{
                    print(error)
                    print("ERROR COULDNT ADD ITEM")
                }
            }
        }
    }
    
    
}

//struct ImageReminderView_Previews: PreviewProvider {
//    static var previews: some View {
//        ImageReminderView()
//    }
//}
