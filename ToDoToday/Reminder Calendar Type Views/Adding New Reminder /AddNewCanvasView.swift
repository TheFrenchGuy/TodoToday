//
//  AddNewCanvasView.swift
//  ToDoToday
//
//  Created by Noe De La Croix on 21/07/2021.
//

import SwiftUI
import PhotosUI

class eventTimeClass {
    var eventDue:Date
    var completionTime: Date
    
    init() {
        self.eventDue = Date()
        self.completionTime = Date().addingTimeInterval(3600) // so that the time is at least an hour apart from the start time
        
    }
}

extension eventTimeClass: Equatable {
    static func == (lhs: eventTimeClass, rhs: eventTimeClass) -> Bool {
        return lhs.eventDue == rhs.eventDue
    }
    
    
}



extension View {
    func hidden(_ shouldHide: Bool) -> some View {
        opacity(shouldHide ? 0 : 1)
    }
}



struct AddNewCanvasView: View {
    
    @Environment (\.managedObjectContext) var viewContext
    @Environment (\.presentationMode) var presentationMode
    
    
    @State private var canvasTitle = ""
    
    
    @State private var eventTime = Date()
    
    @State private var eventtimeclass = eventTimeClass()
    
    @State var showPastTimeAlert: Bool = false
    @State var showTooLateTimeAlert: Bool = false
    @State var showTooLittleTimeAlert: Bool = false
    @Binding var AddedNewCanvas: Bool
    
    
    @State private var showingCanvas: Bool = false
    @State private var showingTypeInterface: Bool = false
    
    
    @State private var typeReminder = TypeReminder.drawing
    @State private var initialUUID: UUID = UUID()
    
    
    @State private var REMDescription: String = ""
    
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var selectedImage: UIImage?
    @State private var isImagePickerDisplay = false
    @State private var isCameraPickerDisplay = false
    
    
    let fileManager = FileManager.default
    let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    let readWriteStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
    
    @State var showPHLibAuth: Bool = false

    
    @StateObject private var audioRec = AudioRecorder()
    
    
    @State private var colorSelected: String = "red"
    @State private var customColor:Color = Color.green
    @State private var calendarName:String = "none"
    
    @EnvironmentObject var transferColorPalette:TransferColorPalette
    
    @EnvironmentObject var hourOfDay:HourOfDay
    
    @EnvironmentObject var taskPerHour:TaskPerHour
    
      
    var body: some View {
        ZStack {
            
        NavigationView{
            VStack {
            Form{
                Section{
                    TextField("Canvas Title", text: $canvasTitle)
                    
                }
                
                Section {
                    VStack(alignment: .leading, spacing: 10) {
                    Text("Type of reminder:")
                        Picker("What type of reminder will it be", selection: $typeReminder, content: {
                            ForEach(TypeReminder.allCases, content: { typeRem in
                                Text(typeRem.rawValue)
                            })
                        }).pickerStyle(SegmentedPickerStyle())
                    }
                }
                
                
                if typeReminder.rawValue == TypeReminder.typed.rawValue {
                    Section {
                 
                        TextField("What your reminder / event", text: $REMDescription)
                    }
                }
                
                if typeReminder.rawValue == TypeReminder.image.rawValue {
                        Section {
                            if selectedImage != nil {
                            Image(uiImage: self.selectedImage!)
                                .resizable()
                                .scaledToFill()
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .edgesIgnoringSafeArea(.all)
                            }
                            Button(action: {
                                            self.isImagePickerDisplay = true
                                        }) {
                                            HStack {
                                                Image(systemName: "photo")
                                                    .font(.system(size: 20))
                                                    
                                                Text("Photo library")
                                                    .font(.headline)
                                            }
                                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50)
                                            .background(Color.blue)
                                            .foregroundColor(.white)
                                            .cornerRadius(20)
                                            .padding(.horizontal)
                                        }
                            
                            Button(action: {
                                            self.isCameraPickerDisplay = true
                                        }) {
                                            HStack {
                                                Image(systemName: "camera.fill")
                                                    .font(.system(size: 20))
                                                    
                                                Text("Camera")
                                                    .font(.headline)
                                            }
                                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50)
                                            .background(Color.blue)
                                            .foregroundColor(.white)
                                            .cornerRadius(20)
                                            .padding(.horizontal)
                                        }
                        }.sheet(isPresented: self.$isImagePickerDisplay) {
//                            ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image)
                            ImagePickerView(selectedImage: self.$selectedImage) { didSelectItem in
                                isImagePickerDisplay = false
                            }
                            
                            
                        }
                        .sheet(isPresented: self.$isCameraPickerDisplay) {
                            PhotoPicker(sourceType: .camera, selectedImage: self.$selectedImage)
                        }
                }
                
                
                if typeReminder.rawValue == TypeReminder.audio.rawValue {
                    AudioRecorderView()
                    Text("\(audioRec.newURL)")
                }
                
                Section {
                    DatePicker("Start time: ", selection: $eventtimeclass.eventDue, displayedComponents: .hourAndMinute).onChange(of: eventtimeclass.eventDue, perform: {value in
                        if eventtimeclass.eventDue.timeIntervalSince(Date()) < 0 {
                            print("Event due is trying to be put in the past")
                            eventtimeclass.eventDue = Date().addingTimeInterval(3600)
                            showPastTimeAlert.toggle()
                        }
                    })
                    
                    DatePicker("Expected Completion time: ", selection: $eventtimeclass.completionTime, displayedComponents: .hourAndMinute).onChange(of: eventtimeclass.completionTime, perform: {value in
                        if eventtimeclass.completionTime.timeIntervalSince(Date()) > 86400 {
                            print("Event your trying to work one has more than a full rotation of the earth")
                            eventtimeclass.completionTime = Date().addingTimeInterval(3600)
                            showTooLateTimeAlert.toggle()
                        }
                        else if eventtimeclass.completionTime.timeIntervalSince(eventtimeclass.eventDue) < 900 {
                            eventtimeclass.completionTime = Date().addingTimeInterval(900)
                            showTooLittleTimeAlert.toggle()
                        }
                    })
                }.alert(isPresented: $showTooLateTimeAlert) {
                    Alert(title: Text("Your task is taking too long, the earth is already able to rotate on itself at least once"))
                }
                
                .alert(isPresented: $showPastTimeAlert) {
                    Alert(title: Text("Well if your trying to set a due date in the past you are late"))
                }
                
                .alert(isPresented: $showTooLittleTimeAlert) {
                    Alert(title: Text("Each of your task needs to be at least 15min long"))
                }
                
                
                Section {
                      
                    NavigationLink(destination: InitialColorPicker(customColor: $customColor, calendarName: $calendarName)) {
                        HStack {
                            Text("Calendar")
                            Spacer()
                            Text(calendarName)
                            Circle().fill(customColor)
                                .frame(width: 25, height: 25)
                        }
                    }
//                    ColorPicker(selection: $customColor, label: {EmptyView()})
                    
                }.onAppear(perform: {if calendarName == "none" {loadFirstCalendar()}}) //So that when it is first being loaded the first entity of the colorpalette is pre loaded
                
                
                
                
                
                
                
                
                
                
            }
                NavigationLink(destination: InitialCanvasDrawingView(id: initialUUID, title: canvasTitle), isActive: $showingCanvas) {EmptyView()}.hidden(showingCanvas)
                NavigationLink(destination: Text("TYPING REMINDER VIEW"), isActive: $showingTypeInterface) {EmptyView()}.hidden(showingTypeInterface)
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .navigationTitle(Text("Add New Canvas"))
            .navigationBarItems(leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Image(systemName: "xmark")
            }), trailing:
                                    Button(action: {
                if !canvasTitle.isEmpty && typeReminder.rawValue == TypeReminder.drawing.rawValue{
                    let drawing = DrawingCanvas(context: viewContext)
                    let date: Date = (Calendar.current.date(bySettingHour: 0, minute: 0, second: 0 , of: Date())!)
                    
                    let timediff = Int(eventtimeclass.eventDue.timeIntervalSince(date))
                    print("TIME DIFFERENCE OF \(timediff)")
                    drawing.title = canvasTitle
                    drawing.startTime = eventtimeclass.eventDue
                    drawing.endTime = eventtimeclass.completionTime
                    drawing.id = UUID()
                    drawing.typeRem = typeReminder.rawValue
                    initialUUID = drawing.id!
                    drawing.tabColor = SerializableColor.init(from: customColor)
                    drawing.calendarNameAdded = calendarName
                    drawing.horizontalPlacement = getxPlacement(time: eventtimeclass.eventDue)
                    //SerializableColorTransformer().transformedValue(customColor) as! SerializableColor
                    
                    
                    
                    
                    
                    do {
                        AddedNewCanvas.toggle()
                        try viewContext.save()
                      //  try viewContext.refreshAllObjects()
                        
                    }
                    catch{
                        print(error)
                        print("ERROR COULDNT ADD ITEM")
                    }
                    
                    //self.presentationMode.wrappedValue.dismiss()
                    
                    showingCanvas.toggle()
                }
                
                else if !canvasTitle.isEmpty && typeReminder.rawValue == TypeReminder.typed.rawValue && !REMDescription.isEmpty{
                    let drawing = DrawingCanvas(context: viewContext)
                    let date: Date = (Calendar.current.date(bySettingHour: 0, minute: 0, second: 0 , of: Date())!)
                    
                    let timediff = Int(eventtimeclass.eventDue.timeIntervalSince(date))
                    print("TIME DIFFERENCE OF \(timediff)")
                    drawing.title = canvasTitle
                    drawing.startTime = eventtimeclass.eventDue
                    drawing.endTime = eventtimeclass.completionTime
                    drawing.id = UUID()
                    drawing.typeRem = typeReminder.rawValue
                    drawing.taskDescription = REMDescription
                    initialUUID = drawing.id!
                    drawing.tabColor = SerializableColor.init(from: customColor)
                    drawing.calendarNameAdded = calendarName
                    drawing.horizontalPlacement = getxPlacement(time: eventtimeclass.eventDue)
                    
                    do {
                        AddedNewCanvas.toggle()
                        try viewContext.save()
                      //  try viewContext.refreshAllObjects()
                        
                    }
                    catch{
                        print(error)
                        print("ERROR COULDNT ADD ITEM")
                    }
                    
                    self.presentationMode.wrappedValue.dismiss()
                    
//                    showingTypeInterface.toggle()
                }
                else if !canvasTitle.isEmpty && typeReminder.rawValue == TypeReminder.image.rawValue {
                    let drawing = DrawingCanvas(context: viewContext)
                    let date: Date = (Calendar.current.date(bySettingHour: 0, minute: 0, second: 0 , of: Date())!)
                    
                    let timediff = Int(eventtimeclass.eventDue.timeIntervalSince(date))
                    print("TIME DIFFERENCE OF \(timediff)")
                    drawing.title = canvasTitle
                    drawing.startTime = eventtimeclass.eventDue
                    drawing.endTime = eventtimeclass.completionTime
                    drawing.id = initialUUID
                    drawing.typeRem = typeReminder.rawValue
                    drawing.tabColor = SerializableColor.init(from: customColor)
                    drawing.calendarNameAdded = calendarName
                    drawing.horizontalPlacement = getxPlacement(time: eventtimeclass.eventDue)
                   
                    print("Image saved as name: \(saveImage(image: self.selectedImage!, id: initialUUID) ?? "IMAGE SAVING ERRROR")") //DEBUG ONLY SINCE IT IS ALREADY PRINTED TO THE CONSOLE WHILE RUING THE FUNCTION
                    
                    do {
                        AddedNewCanvas.toggle()
                        try viewContext.save()
                      //  try viewContext.refreshAllObjects()
                        
                    }
                    catch{
                        print(error)
                        print("ERROR COULDNT ADD ITEM")
                    }
                    
                    self.presentationMode.wrappedValue.dismiss()}
                
                
                else if !canvasTitle.isEmpty && typeReminder.rawValue == TypeReminder.audio.rawValue {
                    
                    let drawing = DrawingCanvas(context: viewContext)
                    let date: Date = (Calendar.current.date(bySettingHour: 0, minute: 0, second: 0 , of: Date())!)
                    
                    let timediff = Int(eventtimeclass.eventDue.timeIntervalSince(date))
                    print("TIME DIFFERENCE OF \(timediff)")
                    drawing.title = canvasTitle
                    drawing.startTime = eventtimeclass.eventDue
                    drawing.endTime = eventtimeclass.completionTime
                    drawing.id = initialUUID
                    drawing.typeRem = typeReminder.rawValue
                   
                    drawing.audioREMurl = audioRec.newURL
                    drawing.tabColor = SerializableColor.init(from: customColor)
                    drawing.calendarNameAdded = calendarName
                    drawing.horizontalPlacement = getxPlacement(time: eventtimeclass.eventDue)
                    
                    
                    do {
                        AddedNewCanvas.toggle()
                        try viewContext.save()
                      //  try viewContext.refreshAllObjects()
                        
                    }
                    catch{
                        print(error)
                        print("ERROR COULDNT ADD ITEM")
                    }
                    
                    self.presentationMode.wrappedValue.dismiss()
                    
                }
                    
                    
                    
                }, label: {
                    Text("Next")
                }))
                
        }
        }
        .environmentObject(audioRec)
    }
    
    //MARK: Load the first Index of the ColorPalette so it does not result in a blank error
    func loadFirstCalendar() {
        calendarName = transferColorPalette.colorpla.first?.title ?? "Please register a calendar"
        customColor = transferColorPalette.colorpla.first? .color ?? Color.clear
    }
    
    //MARK: Save the Canvas as an UIImage
    func saveImage(image: UIImage, id: UUID) -> String? {
  //        let date = String( Date.timeIntervalSinceReferenceDate )
  //        let imageName = date.replacingOccurrences(of: ".", with: "-") + ".png"
        let imageName = String(id.uuidString) // So that will use the UUID from the drawing canvas and name it as its file name, so the file can later just be looked up as the UUID of the canvas and does not need to store an extra propery in coredata.
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
    
    //MARK: This will conver the hex to string
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    
    func getxPlacement(time: Date) -> Double {
        var xlocation: Double = 0.0
        let date: Date = (Calendar.current.date(bySettingHour: 0, minute: 0, second: 0 , of: Date())!)
        
        let timediff = time.timeIntervalSince(date)
        
        if timediff < 86400 && timediff >= 0 {
            if timediff >= 0 && timediff < 3600 {
               print("Drank at 0am")
                
                if self.hourOfDay.midnight.count >= 1 {
                    xlocation = Double(100 * (self.hourOfDay.midnight.count + 1))
                    
                } else {xlocation = 100}
               
                
            }
            
            else if timediff >= 3600 && timediff < 7200 {
                if self.hourOfDay.oneam.count >= 1 {
                    xlocation = Double(100 * (self.hourOfDay.oneam.count + 1))
                    
                } else {xlocation = 100}
               
                
                 
            }
            
            else if timediff >= 7200 && timediff < 10800 {
                print("Drank at 2am")
                
                if self.hourOfDay.twoam.count >= 1 {
                    xlocation = Double(100 * (self.hourOfDay.twoam.count + 1))
                    
                } else {xlocation = 100}
                
                
                
            }
            
            else if timediff >= 10800 && timediff < 14400{
                print("Drank at 3am")
                
                if self.hourOfDay.threeam.count >= 1 {
                    xlocation = Double(100 * (self.hourOfDay.threeam.count + 1))
                    
                } else {xlocation = 100}

            }
            
            else if timediff >= 14400 && timediff < 18000 {
                print("Drank at 4am")
                
                if self.hourOfDay.fouram.count >= 1 {
                    xlocation = Double(100 * (self.hourOfDay.fouram.count + 1))
                    
                } else {xlocation = 100}
                
            }
            
            else if timediff >= 18000 && timediff < 21600 {
                print("Drank at 5am")
                
                if self.hourOfDay.fiveam.count >= 1 {
                    xlocation = Double(100 * (self.hourOfDay.fiveam.count + 1))
                    
                } else {xlocation = 100}
                
                 
            }
            
            else if timediff >= 21600 && timediff < 25200 {
                print("Drank at 6am")
                
                if self.hourOfDay.sixam.count >= 1 {
                    xlocation = Double(100 * (self.hourOfDay.sixam.count + 1))
                    
                } else {xlocation = 100}
                
                
            }
            
            else if timediff >= 25200 && timediff < 28800 {
                print("Drank at 7am")
                
                if self.hourOfDay.sevenam.count >= 1 {
                    xlocation = Double(100 * (self.hourOfDay.sevenam.count + 1))
                    
                } else {xlocation = 100}
                
                
            }
            
            else if timediff >= 28800 && timediff < 32400 {
                print("Drank at 8am")
                
                if self.hourOfDay.eightam.count >= 1 {
                    xlocation = Double(100 * (self.hourOfDay.eightam.count + 1))
                    
                } else {xlocation = 100}
                
                
            }
            
            else if timediff >= 32400 && timediff < 36000 {
                print("Drank at 9am")
                
                if self.hourOfDay.nineam.count >= 1 {
                    xlocation = Double(100 * (self.hourOfDay.nineam.count + 1))
                    
                } else {xlocation = 100}
                
                
            }
            
            else if timediff >= 36000 && timediff < 39600 {
                print("Drank at 10am")
                
                if self.hourOfDay.tenam.count >= 1 {
                    xlocation = Double(100 * (self.hourOfDay.tenam.count + 1))
                    
                } else {xlocation = 100}
                
                 
            }
            
            else if timediff >= 39600 && timediff < 43200 {
                print("Drank at 11am")
                
                if self.hourOfDay.elevenam.count >= 1 {
                    xlocation = Double(100 * (self.hourOfDay.elevenam.count + 1))
                    
                } else {xlocation = 100}
                                
            }
            
            
            else if timediff >= 43200 && timediff < 46800 {
                print("Drank at 12am")
                
                if self.hourOfDay.twelveam.count >= 1 {
                    xlocation = Double(100 * (self.hourOfDay.twelveam.count + 1))
                    
                } else {xlocation = 100}
                
                
            }
            
            else if timediff >= 46800 && timediff < 50400 {
                print("Drank at 1pm")
                
                if self.hourOfDay.onepm.count >= 1 {
                    xlocation = Double(100 * (self.hourOfDay.onepm.count + 1))
                    
                } else {xlocation = 100}
                
                    
            }
            
            else if timediff >= 50400 && timediff < 54000 {
                print("Drank at 2pm")
                
                if self.hourOfDay.twopm.count >= 1 {
                    xlocation = Double(100 * (self.hourOfDay.twopm.count + 1))
                    
                } else {xlocation = 100}
                
            }
            
            else if timediff >= 54000 && timediff < 57600 {
                print("Drank at 3pm")
                
                if self.hourOfDay.threepm.count >= 1 {
                    xlocation = Double(100 * (self.hourOfDay.threepm.count + 1))
                    
                } else {xlocation = 100}
                
                 
            }
            
            else if timediff >= 57600 && timediff < 61200 {
                print("Drank at 4pm")
                
                if self.hourOfDay.fourpm.count >= 1 {
                    xlocation = Double(100 * (self.hourOfDay.fourpm.count + 1))
                    
                } else {xlocation = 100}
                
               
                 
            }
            
            else if timediff >= 61200 && timediff < 64800 {
                print("Drank at 5pm")
                if self.hourOfDay.fivepm.count >= 1 {
                    xlocation = Double(100 * (self.hourOfDay.fivepm.count + 1))
                    
                } else {xlocation = 100}
                
               
                
                 
            }
            
            else if timediff >= 64800 && timediff < 68400 {
                print("Drank at 6pm")
                
                if self.hourOfDay.sixpm.count >= 1 {
                    xlocation = Double(100 * (self.hourOfDay.sixpm.count + 1))
                    
                } else {xlocation = 100}
                
            }
            
            else if timediff >= 68400 && timediff < 72000 {
                print("Drank at 7pm")
                
                if self.hourOfDay.sevenpm.count >= 1 {
                    xlocation = Double(100 * (self.hourOfDay.sevenpm.count + 1))
                    
                } else {xlocation = 100}
                
               
                
            }
            
            
            else if timediff >= 72000 && timediff < 75600 {
                print("Drank at 8pm")
                
                if self.hourOfDay.eightpm.count >= 1 {
                    xlocation = Double(100 * (self.hourOfDay.eightpm.count + 1))
                    
                } else {xlocation = 100}
                
                
            }
            
            else if timediff >= 75600 && timediff < 79200 {
                print("Drank at 9pm")
                
                if self.hourOfDay.ninepm.count >= 1 {
                    xlocation = Double(100 * (self.hourOfDay.ninepm.count + 1))
                    
                } else {xlocation = 100}
                
               
            }
            
            else if timediff >= 79200 && timediff < 82800 {
                print("Drank at 10pm")
                
                if self.hourOfDay.tenpm.count >= 1 {
                    xlocation = Double(100 * (self.hourOfDay.tenpm.count + 1))
                    
                } else {xlocation = 100}
                
                
            }
            
            else if timediff >= 82800 && timediff < 86400 {
                print("Drank at 11pm")
                
                if self.hourOfDay.elevenpm.count >= 1 {
                    xlocation = Double(100 * (self.hourOfDay.elevenpm.count + 1))
                    
                } else {xlocation = 100}
                 
            }
        }
        
        
        
        return xlocation
    }
    
  
    
  
    
    
}

//struct AddNewCanvasView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddNewCanvasView()
//    }
//}


