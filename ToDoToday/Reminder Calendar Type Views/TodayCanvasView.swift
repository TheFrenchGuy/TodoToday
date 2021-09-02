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
    
    
//    @FetchRequest(entity: ColorPalette.entity(), sortDescriptors: []) var colorpalette: FetchedResults<ColorPalette>
    
    
    @State private var showSheet = false
    @State private var test = false
    
    @StateObject var hourOfDay = HourOfDay()
    
    let fileManager = FileManager.default
    let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    @State var AddedNewCanvas: Bool = false
    
    @EnvironmentObject var tabViewClass:TabViewClass
    
    @EnvironmentObject var transferColorPalette:TransferColorPalette
    @EnvironmentObject var refreshListClass:RefreshListClass
    
    @EnvironmentObject var taskPerHour:TaskPerHour
    
   
    
    

    var body: some View {
        ZStack {
            GeometryReader { bounds in
                VStack{
                        if !checkIfDrawingstoday() {
                            PlaceholderView()

                            Button(action: {
                                self.showSheet.toggle()
                            }, label: {
                                HStack{
                                    Image(systemName: "plus")
                                    Text("Add Canvas !!!")
                                }
                            }).keyboardShortcut("n")
                            .foregroundColor(.blue)
                            .sheet(isPresented: $showSheet , content: {
                                AddNewCanvasView(AddedNewCanvas: $AddedNewCanvas).environment(\.managedObjectContext, viewContext)

                            })
                            
                            .sheet(isPresented: $tabViewClass.addNewTask , content: {
                                AddNewCanvasView(AddedNewCanvas: $AddedNewCanvas).environment(\.managedObjectContext, viewContext)

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
                                }).keyboardShortcut("n")
                                .foregroundColor(.blue)
                                .sheet(isPresented: $showSheet, content: {
                                    AddNewCanvasView(AddedNewCanvas: $AddedNewCanvas).environment(\.managedObjectContext, viewContext)
                                
                                })
                                
                                .sheet(isPresented: $tabViewClass.addNewTask , content: {
                                    AddNewCanvasView(AddedNewCanvas: $AddedNewCanvas).environment(\.managedObjectContext, viewContext)

                                })
                                
                                
                                
                                    }
                                

                            CalendarView(RefreshList: $AddedNewCanvas)
                                
                                    
                                    .onChange(of: AddedNewCanvas) {newValue in getHoursByHoursTabs()
                                    print("UPDATED TABLE")
                                        }.onAppear(perform: {self.getHoursByHoursTabs()})
                                
                                
                            
                    
                    
                }
                }.frame(width: bounds.size.width, height: bounds.size.height)
                    .onAppear(perform: {self.getHoursByHoursTabs()})
                    .onChange(of: refreshListClass.refresh, perform: {newValue in
                        getHoursByHoursTabs(); print("NEW FETCH REQUEST")})
        }
        }.environmentObject(hourOfDay)
          
    
        
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
        self.hourOfDay.objectWillChange.send()
        self.taskPerHour.objectWillChange.send()
        
  
            print("RUNNING")
        let date: Date = (Calendar.current.date(bySettingHour: 0, minute: 0, second: 0 , of: Date())!)
        var viewContext: NSManagedObjectContext { PersistenceController.shared.container.viewContext } //remove error from '+entityForName: nil is not a legal NSManagedObjectContext parameter searching for entity name
        let req = NSFetchRequest<NSFetchRequestResult>(entityName: "DrawingCanvas")
        
        do {
            let result = try viewContext.fetch(req)
            
            self.taskPerHour.fourpm = 0
            
            
            self.hourOfDay.midnight.removeAll()
            self.hourOfDay.oneam.removeAll()
            self.hourOfDay.twoam.removeAll()
            self.hourOfDay.threeam.removeAll()
            self.hourOfDay.fouram.removeAll()

            self.hourOfDay.fiveam.removeAll()

            self.hourOfDay.sixam.removeAll()
            self.hourOfDay.sevenam.removeAll()
            self.hourOfDay.eightam.removeAll()

            self.hourOfDay.nineam.removeAll()

            self.hourOfDay.tenam.removeAll()
            self.hourOfDay.elevenam.removeAll()

            self.hourOfDay.twelveam.removeAll()

            self.hourOfDay.onepm.removeAll()
            self.hourOfDay.twopm.removeAll()

            self.hourOfDay.threepm.removeAll()
            self.hourOfDay.fourpm.removeAll()

            self.hourOfDay.fivepm.removeAll()

            self.hourOfDay.sixpm.removeAll()
            self.hourOfDay.sevenpm.removeAll()
            self.hourOfDay.eightpm.removeAll()

            self.hourOfDay.ninepm.removeAll()

            self.hourOfDay.tenpm.removeAll()
            self.hourOfDay.elevenpm.removeAll()
            
            for i in result as! [NSManagedObject] {
                let id = i.value(forKey: "id") as! UUID
                let startTime = i.value(forKey: "startTime") as? Date ?? Date()
                
               // print("UUID OF \(id)")
                let timediff = Int(startTime.timeIntervalSince(date))
                
                if timediff < 86400 && timediff >= 0 {
                    if timediff >= 0 && timediff < 3600 {
                       print("Drank at 0am")
                        self.hourOfDay.midnight.append(id)
                        
                    }
                    
                    else if timediff >= 3600 && timediff < 7200 {
                       
                        self.hourOfDay.oneam.append(id)
                         
                    }
                    
                    else if timediff >= 7200 && timediff < 10800 {
                        print("Drank at 2am")
                        
                        self.hourOfDay.twoam.append(id)
                        
                    }
                    
                    else if timediff >= 10800 && timediff < 14400{
                        print("Drank at 3am")
                        self.hourOfDay.threeam.append(id)
                    }
                    
                    else if timediff >= 14400 && timediff < 18000 {
                        print("Drank at 4am")
                        self.hourOfDay.fouram.append(id)
                    }
                    
                    else if timediff >= 18000 && timediff < 21600 {
                        print("Drank at 5am")
                        self.hourOfDay.fiveam.append(id)
                         
                    }
                    
                    else if timediff >= 21600 && timediff < 25200 {
                        print("Drank at 6am")
                        self.hourOfDay.sixam.append(id)
                        
                    }
                    
                    else if timediff >= 25200 && timediff < 28800 {
                        print("Drank at 7am")
                        self.hourOfDay.sevenam.append(id)
                        
                    }
                    
                    else if timediff >= 28800 && timediff < 32400 {
                        print("Drank at 8am")
                        self.hourOfDay.eightam.append(id)
                        
                    }
                    
                    else if timediff >= 32400 && timediff < 36000 {
                        print("Drank at 9am")
                        self.hourOfDay.nineam.append(id)
                        
                    }
                    
                    else if timediff >= 36000 && timediff < 39600 {
                        print("Drank at 10am")
                        self.hourOfDay.tenam.append(id)
                         
                    }
                    
                    else if timediff >= 39600 && timediff < 43200 {
                        print("Drank at 11am")
                        self.hourOfDay.elevenam.append(id)
                        
                    }
                    
                    
                    else if timediff >= 43200 && timediff < 46800 {
                        print("Drank at 12am")
                        self.hourOfDay.twelveam.append(id)
                        
                    }
                    
                    else if timediff >= 46800 && timediff < 50400 {
                        print("Drank at 1pm")
                        self.hourOfDay.onepm.append(id)
                            
                    }
                    
                    else if timediff >= 50400 && timediff < 54000 {
                        print("Drank at 2pm")
                        self.hourOfDay.twopm.append(id)
                    }
                    
                    else if timediff >= 54000 && timediff < 57600 {
                        print("Drank at 3pm")
                        self.hourOfDay.threepm.append(id)
                         
                    }
                    
                    else if timediff >= 57600 && timediff < 61200 {
                        print("Drank at 4pm")
                        self.hourOfDay.fourpm.append(id)
                       
                         
                    }
                    
                    else if timediff >= 61200 && timediff < 64800 {
                        print("Drank at 5pm")
                        self.hourOfDay.fivepm.append(id)
                       
                        
                         
                    }
                    
                    else if timediff >= 64800 && timediff < 68400 {
                        print("Drank at 6pm")
                        self.hourOfDay.sixpm.append(id)
                    }
                    
                    else if timediff >= 68400 && timediff < 72000 {
                        print("Drank at 7pm")
                        self.hourOfDay.sevenpm.append(id)
                       
                        
                    }
                    
                    
                    else if timediff >= 72000 && timediff < 75600 {
                        print("Drank at 8pm")
                        self.hourOfDay.eightpm.append(id)
                        
                    }
                    
                    else if timediff >= 75600 && timediff < 79200 {
                        print("Drank at 9pm")
                        self.hourOfDay.ninepm.append(id)
                       
                    }
                    
                    else if timediff >= 79200 && timediff < 82800 {
                        print("Drank at 10pm")
                        self.hourOfDay.tenpm.append(id)
                        
                    }
                    
                    else if timediff >= 82800 && timediff < 86400 {
                        print("Drank at 11pm")
                        self.hourOfDay.elevenpm.append(id)
                        
                         
                    }
                }
                
                
            }
            print("ARRAY SIZE: \(hourOfDay.tenpm.count)")
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    func checkIfDrawingstoday() -> Bool {
        let date: Date = (Calendar.current.date(bySettingHour: 0, minute: 0, second: 1 , of: Date())!)
        var viewContext: NSManagedObjectContext { PersistenceController.shared.container.viewContext } //remove error from '+entityForName: nil is not a legal NSManagedObjectContext parameter searching for entity name
        let req = NSFetchRequest<NSFetchRequestResult>(entityName: "DrawingCanvas")
        
        do {
            let result = try viewContext.fetch(req)
            
            for i in result as! [NSManagedObject] {
                let startTime = i.value(forKey: "startTime") as? Date ?? (Calendar.current.date(bySettingHour: 0, minute: 0, second: 1 , of: Date().addingTimeInterval(-86500))!)
                let timediff = Int(startTime.timeIntervalSince(date))
                
                if timediff < 86400 && timediff >= 0 {
                    print("Start Time: \(startTime)")
                    return true
                    
                    
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return false
    }
    
}


//struct TodayCanvas_Previews: PreviewProvider {
//    static var previews: some View {
//        TodayCanvasView()
//    }
//}




//                                List {
//                                    ForEach(drawings){drawing in
//                                      //  if !sixpm.isEmpty {
//                                          //  if drawing.id == dataHoursUUID.twopm[0] {
//                                            HStack () {
//                                                if getWallpaperFromUserDefaults() != nil {
//                                                    Image(uiImage: fetchImage(imageName: String("\(drawing.id)")) ?? UIImage(data: getWallpaperFromUserDefaults()!)! ).resizable().scaledToFit().frame(width: 100, height: 100)
//
//                                                }
//
//                                                Button(action: { test.toggle(); print("Keyboard shortcut pressed")}) { Text("Tap here")}.keyboardShortcut("l", modifiers: .command)
//                                                Text("Canvas, \(drawing.id ?? UUID()), \(drawing.title ?? "NO TITLE ")").sheet(isPresented: self.$test) {
//                                                    DrawingView(isVisible: $test, id: drawing.id, data: drawing.canvasData, title: drawing.title)
//                                                }
//
//                                                Text("\(drawing.timeEvent ?? Date())")
//
//                                            }.contextMenu { Button(action: {
//                                                viewContext.delete(drawing)
//                                                deleteImage(imageName: String("\(drawing.id)"))
//                                                do {
//                                                    try self.viewContext.save()
//                                                } catch {
//                                                    print(error)
//                                                }
//                                            }) {
//                                                Text("Delete me")
//                                            }
//
//                                            }
//                                          //  }
//                                      //  }
//
//                                    }
//                                    .onDelete(perform: deleteItem)
//
////                                    Button(action: {
////                                        self.showSheet.toggle()
////                                    }, label: {
////                                        HStack{
////                                            Image(systemName: "plus")
////                                            Text("Add Canvas")
////                                        }
////                                    })
////                                    .foregroundColor(.blue)
////                                    .sheet(isPresented: $showSheet, content: {
////                                        AddNewCanvasView().environment(\.managedObjectContext, viewContext)
////                                    })
//                                }
