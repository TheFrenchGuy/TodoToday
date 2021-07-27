//
//  TodayCanvasView.swift
//  ToDoToday
//
//  Created by Noe De La Croix on 21/07/2021.
//

import SwiftUI
import CoreData
import Combine


//class DataHoursUUID {
//    @State var midnight: [UUID] = []
//    var oneam: [UUID] = []
//    var twoam: [UUID] = []
//    var threeam: [UUID] = []
//    var fouram: [UUID] = []
//    var fiveam: [UUID] = []
//    var sixam: [UUID] = []
//    var sevenam: [UUID] = []
//    var eightam: [UUID] = []
//    var nineam: [UUID] = []
//    var tenam: [UUID] = []
//    var elevenam: [UUID] = []
//    var twelveam: [UUID] = []
//    var onepm: [UUID] = []
//    var twopm: [UUID] = []
//    var threepm: [UUID] = []
//    var fourpm: [UUID] = []
//    var fivepm: [UUID] = []
//    @State var sixpm: [UUID] = []
//    var sevenpm: [UUID] = []
//    var eightpm: [UUID] = []
//    var ninepm: [UUID] = []
//    var tenpm: [UUID] = []
//    var elevenpm: [UUID] = []
//}

extension Array: Identifiable where Element: Hashable {
   public var id: Self { self }
}

struct TodayCanvasView: View {
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(entity: DrawingCanvas.entity(), sortDescriptors: []) var drawings: FetchedResults<DrawingCanvas>
//    @State var dataHoursUUID = DataHoursUUID()
    
    
    @State private var showSheet = false
    @State private var test = false
    
    
    
    let fileManager = FileManager.default
    let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    

    
    
    @State var midnight: [UUID] = []
    @State var oneam: [UUID] = []
    @State var twoam: [UUID] = []
    @State var threeam: [UUID] = []
    @State var fouram: [UUID] = []
    @State var fiveam: [UUID] = []
    @State var sixam: [UUID] = []
    @State var sevenam: [UUID] = []
    @State var eightam: [UUID] = []
    @State var nineam: [UUID] = []
    @State var tenam: [UUID] = []
    @State var elevenam: [UUID] = []
    @State var twelveam: [UUID] = []
    @State var onepm: [UUID] = []
    @State var twopm: [UUID] = []
    @State var threepm: [UUID] = []
    @State var fourpm: [UUID] = []
    @State var fivepm: [UUID] = []
    @State var sixpm: [UUID] = []
    @State var sevenpm: [UUID] = []
    @State var eightpm: [UUID] = []
    @State var ninepm: [UUID] = []
    @State var tenpm: [UUID] = []
    @State var elevenpm: [UUID] = []
    
    @State var AddedNewCanvas: Bool = false
    
    

    var body: some View {
        ZStack {
            GeometryReader { bounds in
                VStack{
                        if drawings.count == 0 { //MARK: WILL NEED TO IMPLEMENT WHEN THERE ARE NOT DRAWINGS FOR THAT DAY 
                            PlaceholderView()
                            
                            Button(action: {
                                self.showSheet.toggle()
                            }, label: {
                                HStack{
                                    Image(systemName: "plus")
                                    Text("Add Canvas !!!")
                                }
                            })
                            .foregroundColor(.blue)
                            .sheet(isPresented: $showSheet, content: {
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
                                })
                                .foregroundColor(.blue)
                                .sheet(isPresented: $showSheet, content: {
                                    AddNewCanvasView(AddedNewCanvas: $AddedNewCanvas).environment(\.managedObjectContext, viewContext)
                                
                                })
                              //  .onChange(of: self.AddedNewCanvas) {getHoursByHoursTabs()}
                                
//
                                CalendarView(midnight: $midnight, oneam: $oneam, twoam: $twoam, threeam: $threeam, fouram: $fouram, fiveam: $fiveam, sixam: $sixam, sevenam: $sevenam, eightam: $eightam, nineam: $nineam, tenam: $tenam, elevenam: $elevenam, twelveam: $twelveam, onepm: $onepm, twopm: $twopm, threepm: $threepm, fourpm: $fourpm, fivepm: $fivepm, sixpm: $sixpm, sevenpm: $sevenpm, eightpm: $eightpm, ninepm: $ninepm, tenpm: $tenpm, elevenpm: $elevenpm, RefreshList: $AddedNewCanvas).onChange(of: AddedNewCanvas) {newValue in getHoursByHoursTabs()
                                    print("UPDATED TABLE")
                                }
                                
                                
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

                            }.onAppear(perform: {self.getHoursByHoursTabs()})

                    
                    
                    
                }
                }.frame(width: bounds.size.width, height: bounds.size.height)
                    .onAppear(perform: {self.getHoursByHoursTabs()})
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
  //     Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            print("RUNNING")
        let date: Date = (Calendar.current.date(bySettingHour: 0, minute: 0, second: 0 , of: Date())!)
        var viewContext: NSManagedObjectContext { PersistenceController.shared.container.viewContext } //remove error from '+entityForName: nil is not a legal NSManagedObjectContext parameter searching for entity name
        let req = NSFetchRequest<NSFetchRequestResult>(entityName: "DrawingCanvas")
        
        do {
            let result = try viewContext.fetch(req)
            
            self.midnight.removeAll()
            self.oneam.removeAll()
            self.twoam.removeAll()
            self.threeam.removeAll()
            self.fouram.removeAll()

            self.fiveam.removeAll()

            self.sixam.removeAll()
            self.sevenam.removeAll()
            self.eightam.removeAll()

            self.nineam.removeAll()

            self.tenam.removeAll()
            self.elevenam.removeAll()

            self.twelveam.removeAll()

            self.onepm.removeAll()
            self.twopm.removeAll()

            self.threepm.removeAll()
            self.fourpm.removeAll()

            self.fivepm.removeAll()

            self.sixpm.removeAll()
            self.sevenpm.removeAll()
            self.eightpm.removeAll()

            self.ninepm.removeAll()

            self.tenpm.removeAll()
            self.elevenpm.removeAll()
            
            for i in result as! [NSManagedObject] {
                let id = i.value(forKey: "id") as! UUID
                let timeEvent = i.value(forKey: "timeEvent") as? Date ?? Date()
                
               // print("UUID OF \(id)")
                let timediff = Int(timeEvent.timeIntervalSince(date))
                
                if timediff < 86400 && timediff >= 0 {
                    if timediff >= 0 && timediff < 3600 {
                       print("Drank at 0am")
                        self.midnight.append(id)
                        
                    }
                    
                    else if timediff >= 3600 && timediff < 7200 {
                       
                        self.oneam.append(id)
                         
                    }
                    
                    else if timediff >= 7200 && timediff < 10800 {
                        print("Drank at 2am")
                        
                        self.twoam.append(id)
                        
                    }
                    
                    else if timediff >= 10800 && timediff < 14400{
                        print("Drank at 3am")
                        self.threeam.append(id)
                    }
                    
                    else if timediff >= 14400 && timediff < 18000 {
                        print("Drank at 4am")
                        self.fouram.append(id)
                    }
                    
                    else if timediff >= 18000 && timediff < 21600 {
                        print("Drank at 5am")
                        self.fiveam.append(id)
                         
                    }
                    
                    else if timediff >= 21600 && timediff < 25200 {
                        print("Drank at 6am")
                        self.sixam.append(id)
                        
                    }
                    
                    else if timediff >= 25200 && timediff < 28800 {
                        print("Drank at 7am")
                        self.sevenam.append(id)
                        
                    }
                    
                    else if timediff >= 28800 && timediff < 32400 {
                        print("Drank at 8am")
                        self.eightam.append(id)
                        
                    }
                    
                    else if timediff >= 32400 && timediff < 36000 {
                        print("Drank at 9am")
                        self.nineam.append(id)
                        
                    }
                    
                    else if timediff >= 36000 && timediff < 39600 {
                        print("Drank at 10am")
                        self.tenam.append(id)
                         
                    }
                    
                    else if timediff >= 39600 && timediff < 43200 {
                        print("Drank at 11am")
                        self.elevenam.append(id)
                        
                    }
                    
                    
                    else if timediff >= 43200 && timediff < 46800 {
                        print("Drank at 12am")
                        self.twelveam.append(id)
                        
                    }
                    
                    else if timediff >= 46800 && timediff < 50400 {
                        print("Drank at 1pm")
                        self.onepm.append(id)
                            
                    }
                    
                    else if timediff >= 50400 && timediff < 54000 {
                        print("Drank at 2pm")
                        
                        if !twopm.isEmpty {
                            print("ITEMS AT 2PM \(self.twopm[0])")
                        }
                        self.twopm.append(id)
                    }
                    
                    else if timediff >= 54000 && timediff < 57600 {
                        print("Drank at 3pm")
                        self.threepm.append(id)
                         
                    }
                    
                    else if timediff >= 57600 && timediff < 61200 {
                        print("Drank at 4pm")
                        self.fourpm.append(id)
                         
                    }
                    
                    else if timediff >= 61200 && timediff < 64800 {
                        print("Drank at 5pm")
                        self.fivepm.append(id)
                         
                    }
                    
                    else if timediff >= 64800 && timediff < 68400 {
                        print("Drank at 6pm")
                        self.sixpm.append(id)
                    }
                    
                    else if timediff >= 68400 && timediff < 72000 {
                        print("Drank at 7pm")
                        self.sevenpm.append(id)
                       
                        
                    }
                    
                    
                    else if timediff >= 72000 && timediff < 75600 {
                        print("Drank at 8pm")
                        self.eightpm.append(id)
                        
                    }
                    
                    else if timediff >= 75600 && timediff < 79200 {
                        print("Drank at 9pm")
                        self.ninepm.append(id)
                       
                    }
                    
                    else if timediff >= 79200 && timediff < 82800 {
                        print("Drank at 10pm")
                        self.tenpm.append(id)
                        
                    }
                    
                    else if timediff >= 82800 && timediff < 86400 {
                        print("Drank at 11pm")
                        self.elevenpm.append(id)
                        
                         
                    }
                }
                
            }
        } catch {
            print(error.localizedDescription)
        }
        
      //  }
    }
    
}


struct TodayCanvas_Previews: PreviewProvider {
    static var previews: some View {
        TodayCanvasView()
    }
}




