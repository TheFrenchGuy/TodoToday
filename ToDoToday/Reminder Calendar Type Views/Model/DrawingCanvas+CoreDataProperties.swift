//
//  DrawingCanvas+CoreDataProperties.swift
//  ToDoToday
//
//  Created by Noe De La Croix on 29/07/2021.
//
//

import Foundation
import CoreData


extension DrawingCanvas {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DrawingCanvas> {
        return NSFetchRequest<DrawingCanvas>(entityName: "DrawingCanvas")
    }

    @NSManaged public var canvasData: Data?
    @NSManaged public var id: UUID?
    @NSManaged public var timeEvent: Date?
    @NSManaged public var title: String?
    
    @NSManaged public var taskDescription: String?
    @NSManaged public var taskColor: String?

}

extension DrawingCanvas : Identifiable {
    @NSManaged public var typeRem: String
    
    var typereminder: TypeReminder {
        set {
            typeRem = newValue.rawValue
        }
        get {
            TypeReminder(rawValue: typeRem) ?? .drawing
        }
    }
}


extension DrawingCanvas {
    
}

