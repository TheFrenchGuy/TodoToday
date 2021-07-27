//
//  HoursView.swift
//  ToDoToday
//
//  Created by Noe De La Croix on 23/07/2021.
//

import SwiftUI
import Combine
import CoreData
import Foundation

struct HoursView: View {
    
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(entity: DrawingCanvas.entity(), sortDescriptors: []) var drawings: FetchedResults<DrawingCanvas>

    @State private var showSheet = false
   
    @Binding var ArrayHourUUID: [UUID]
    var ShowTime: String
    @State private var test = false
    
    @EnvironmentObject var hourOfDay: HourOfDay
    
    
    let fileManager = FileManager.default
    let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    @State var AddedNewCanvas: Bool = false
    @Binding var RefreshList: Bool
    
    @State var currentUUID: UUID?
    @State var currentTitle: String = "NOT LOADED"
    @State var currentData: Data?
    
    var body: some View {
        ZStack {
            GeometryReader { bounds in
                ScrollView(.horizontal) {
                HStack {
                    
                    if hourOfDay.fivepm.isEmpty {
                        Image(systemName: "exclamationmark.triangle")
                    }
                    
                   
                    Text(ShowTime)
                    ForEach(drawings, id: \.self){drawing in
                       EnumeratedForEach(ArrayHourUUID) { index, TimeUUID in
                            if !ArrayHourUUID.isEmpty {
                                    
                                    
                                    if TimeUUID == drawing.id {
                            
                                        HStack (){
                                    
                                    
                                    

                                    Button(action: {
                                        fetchProperties(canvasUUID: drawing.id ?? UUID(), index: index);
                                        test.toggle();
                                        print("Keyboard shortcut pressed");
                                    }) {
        //                                Text("Tap here").keyboardShortcut("l", modifiers: .command)
                                        if getWallpaperFromUserDefaults() != nil {
                                            Image(uiImage: fetchImage(imageName: String("\(drawing.id)")) ?? UIImage(data: getWallpaperFromUserDefaults()!)! ).resizable().scaledToFit().frame(width: 150, height: 150)
                                                .keyboardShortcut("l", modifiers: .command)

                                        
                                    }
                                        Text("Drawing \(drawing.title ?? "NO TITLE")")
                                       

                                    }
                                        .sheet(isPresented: self.$test) {
                                            DrawingView(isVisible: $test, id: currentUUID, data: currentData, title: currentTitle)
                                                .onDisappear() { print("DISMISS"); RefreshList.toggle()}
                                            
                                        }
                                        
                                    
        //                            Text("\(drawing.timeEvent ?? Date())")

                                }                            .contextMenu { Button(action: {
                                    viewContext.delete(drawing)
                                    deleteImage(imageName: String("\(drawing.id)"))
                                    do {
                                        try self.viewContext.save()
                                        print("DELETED ITEM")
                                    } catch {
                                        print(error)
                                    }
                                }) {
                                    Text("Delete me")
                                }
                                    
                                }
                                .onChange(of: TimeUUID, perform: {newValue in
                                    fetchProperties(canvasUUID: drawing.id ?? UUID(), index: index)})
                                
                                
                                }
                               
                            }

                            
                                
                        }
                        
                        
                        
                        }
                        
                        .onDelete(perform: deleteItem)
                        
                        .foregroundColor(.blue)
                        .sheet(isPresented: $showSheet, content: {
                            AddNewCanvasView(AddedNewCanvas: $AddedNewCanvas).environment(\.managedObjectContext, viewContext)
                        })
                }
                    
                }.frame(height: 200)
                
                Divider()
            }
        }
            

        
    }
    func deleteItem(at offset: IndexSet) {
        for index in offset{
            let itemToDelete = drawings[index]
            viewContext.delete(itemToDelete)
            deleteImage(imageName: String("\(drawings[index].id)"))
            do{
                try viewContext.save()
                print("DELETED ITEM")
            }
            catch{
                print(error)
            }
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
    
    
    func fetchInitialProperties() {
        for drawing in drawings {
            for ArrayHourUUID in ArrayHourUUID {
                if ArrayHourUUID == drawing.id {
                    currentUUID = drawing.id!
                    currentTitle = drawing.title!
                    currentData = drawing.canvasData
                }
            }

        }
    }
    
    
    func fetchProperties(canvasUUID: UUID?, index: Int) {
        for drawing in drawings {
                if ArrayHourUUID[index] == drawing.id {
                    currentUUID = ArrayHourUUID[index]
                    currentTitle = drawing.title!
                    currentData = drawing.canvasData
                } else {
                    print("THERE ARE NO RECORD")
                }
        }
            }
        
    }
    
    
//struct HoursView_Previews: PreviewProvider {
//    static var previews: some View {
//        HoursView()
//    }
//}

public struct ForEachWithIndex<Data: RandomAccessCollection, ID: Hashable, Content: View>: View {
    public var data: Data
    public var content: (_ index: Data.Index, _ element: Data.Element) -> Content
    var id: KeyPath<Data.Element, ID>

    public init(_ data: Data, id: KeyPath<Data.Element, ID>, content: @escaping (_ index: Data.Index, _ element: Data.Element) -> Content) {
        self.data = data
        self.id = id
        self.content = content
    }

    public var body: some View {
        ForEach(
            zip(self.data.indices, self.data).map { index, element in
                IndexInfo(
                    index: index,
                    id: self.id,
                    element: element
                )
            },
            id: \.elementID
        ) { indexInfo in
            self.content(indexInfo.index, indexInfo.element)
        }
    }
}

extension ForEachWithIndex where ID == Data.Element.ID, Content: View, Data.Element: Identifiable {
    public init(_ data: Data, @ViewBuilder content: @escaping (_ index: Data.Index, _ element: Data.Element) -> Content) {
        self.init(data, id: \.id, content: content)
    }
}

extension ForEachWithIndex: DynamicViewContent where Content: View {
}

private struct IndexInfo<Index, Element, ID: Hashable>: Hashable {
    let index: Index
    let id: KeyPath<Element, ID>
    let element: Element

    var elementID: ID {
        self.element[keyPath: self.id]
    }

    static func == (_ lhs: IndexInfo, _ rhs: IndexInfo) -> Bool {
        lhs.elementID == rhs.elementID
    }

    func hash(into hasher: inout Hasher) {
        self.elementID.hash(into: &hasher)
    }
}


struct EnumeratedForEach<ItemType, ContentView: View>: View {
    let data: [ItemType]
    let content: (Int, ItemType) -> ContentView
    
    init(_ data: [ItemType], @ViewBuilder content: @escaping (Int, ItemType) -> ContentView) {
        self.data = data
        self.content = content
    }
    
    var body: some View {
        ForEach(Array(self.data.enumerated()), id: \.offset) { idx, item in
            self.content(idx, item)
        }
    }
}
