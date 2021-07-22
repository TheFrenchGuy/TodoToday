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
    
    @State var HoursPerHoursTask = []
    
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
                                
                          
//                                List {
//                                    ForEach(drawings){drawing in
//                                        HStack () {
//                                            if getWallpaperFromUserDefaults() != nil {
//                                                Image(uiImage: fetchImage(imageName: String("\(drawing.id)")) ?? UIImage(data: getWallpaperFromUserDefaults()!)! ).resizable().scaledToFit().frame(width: 100, height: 100)
//
//                                            }
//
//                                            Button(action: { test.toggle(); print("Keyboard shortcut pressed")}) { Text("Tap here")}.keyboardShortcut("l", modifiers: .command)
//                                            Text("Canvas, \(drawing.id ?? UUID()), \(drawing.title ?? "NO TITLE ")").sheet(isPresented: self.$test) {
//                                                DrawingView(isVisible: $test, id: drawing.id, data: drawing.canvasData, title: drawing.title)
//                                            }
//
//                                        }.contextMenu { Button(action: {
//                                            viewContext.delete(drawing)
//                                            deleteImage(imageName: String("\(drawing.id)"))
//                                            do {
//                                                try self.viewContext.save()
//                                            } catch {
//                                                print(error)
//                                            }
//                                        }) {
//                                            Text("Delete me")
//                                        }}
//
//
//                                    }
//                                    .onDelete(perform: deleteItem)
//
//                                    Button(action: {
//                                        self.showSheet.toggle()
//                                    }, label: {
//                                        HStack{
//                                            Image(systemName: "plus")
//                                            Text("Add Canvas")
//                                        }
//                                    })
//                                    .foregroundColor(.blue)
//                                    .sheet(isPresented: $showSheet, content: {
//                                        AddNewCanvasView().environment(\.managedObjectContext, viewContext)
//                                    })
//                                }

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
    
    
    func getHoursByHoursTabs() {
        
        let date: Date = (Calendar.current.date(bySettingHour: 0, minute: 0, second: 0 , of: Date())!)
        var viewContext: NSManagedObjectContext { PersistenceController.shared.container.viewContext } //remove error from '+entityForName: nil is not a legal NSManagedObjectContext parameter searching for entity name
        let req = NSFetchRequest<NSFetchRequestResult>(entityName: "DrawingCanvas")
        
        do {
            let result = try viewContext.fetch(req)
            
            for i in result as! [NSManagedObject] {
                let id = i.value(forKey: "id") as! UUID
                let timeEvent = i.value(forKey: "timeEvent") as! Date
                
                
                let timediff = Int(timeEvent.timeIntervalSince(date))
                
                if timediff < 86400 && timediff >= 0 {
                    if timediff >= 0 && timediff < 3600 {
                       print("Drank at 0am")
                       
                        
                    }
                    
                    else if timediff >= 3600 && timediff < 7200 {
                        print("Drank at 1am")
                        
                         
                    }
                    
                    else if timediff >= 7200 && timediff < 10800 {
                        print("Drank at 2am")
                       
                        
                    }
                    
                    else if timediff >= 10800 && timediff < 14400{
                        print("Drank at 3am")
                        
                    }
                    
                    else if timediff >= 14400 && timediff < 18000 {
                        print("Drank at 4am")
                        
                    }
                    
                    else if timediff >= 18000 && timediff < 21600 {
                        print("Drank at 5am")
                        
                         
                    }
                    
                    else if timediff >= 21600 && timediff < 25200 {
                        print("Drank at 6am")
                        
                        
                    }
                    
                    else if timediff >= 25200 && timediff < 28800 {
                        print("Drank at 7am")
                        
                        
                    }
                    
                    else if timediff >= 28800 && timediff < 32400 {
                        print("Drank at 8am")
                       
                        
                    }
                    
                    else if timediff >= 32400 && timediff < 36000 {
                        print("Drank at 9am")
                        
                        
                    }
                    
                    else if timediff >= 36000 && timediff < 39600 {
                        print("Drank at 10am")
                        
                         
                    }
                    
                    else if timediff >= 39600 && timediff < 43200 {
                        print("Drank at 11am")
                       
                        
                    }
                    
                    
                    else if timediff >= 43200 && timediff < 46800 {
                        print("Drank at 12am")
                        
                        
                    }
                    
                    else if timediff >= 46800 && timediff < 50400 {
                        print("Drank at 1pm")
                       
                            
                    }
                    
                    else if timediff >= 50400 && timediff < 54000 {
                        print("Drank at 2pm")
                       
                    }
                    
                    else if timediff >= 54000 && timediff < 57600 {
                        print("Drank at 3pm")
                       
                         
                    }
                    
                    else if timediff >= 57600 && timediff < 61200 {
                        print("Drank at 4pm")
                       
                         
                    }
                    
                    else if timediff >= 61200 && timediff < 64800 {
                        print("Drank at 5pm")
                        
                         
                    }
                    
                    else if timediff >= 64800 && timediff < 68400 {
                        print("Drank at 6pm")
                       
                    }
                    
                    else if timediff >= 68400 && timediff < 72000 {
                        print("Drank at 7pm")
                         
                       
                        
                    }
                    
                    
                    else if timediff >= 72000 && timediff < 75600 {
                        print("Drank at 8pm")
                      
                        
                    }
                    
                    else if timediff >= 75600 && timediff < 79200 {
                        print("Drank at 9pm")
                       
                       
                    }
                    
                    else if timediff >= 79200 && timediff < 82800 {
                        print("Drank at 10pm")
                       
                        
                    }
                    
                    else if timediff >= 82800 && timediff < 86400 {
                        print("Drank at 11pm")
                          
                        
                         
                    }
                }
                
            }
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
}


struct TodayCanvas_Previews: PreviewProvider {
    static var previews: some View {
        TodayCanvasView()
    }
}




