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
    @NSManaged public var startTime: Date?
    @NSManaged public var endTime: Date?
    @NSManaged public var title: String?
    
    @NSManaged public var taskDescription: String?
    @NSManaged public var taskColor: String?
    
    @NSManaged public var audioREMurl:String?
    
    @NSManaged public var tabColor: SerializableColor?
    @NSManaged public var calendarNameAdded:String?
    @NSManaged public var completedTask: Bool
    
    
    @NSManaged public var xLocation: Double
    @NSManaged public var yLocation: Double
    
    
    @NSManaged public var alertNotificationTimeBefore: String?
    
    @NSManaged public var imageData: Data?
    @NSManaged public var audioData: Data?
    
    @NSManaged public var isNotificationAlert: Bool
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
    
//    var tabcolorenum: TabColor {
//        set {
//            tabColor = newValue.rawValue
//        } get {
//            TabColor(rawValue: tabColor) ?? .CClear
//        }
//    }
}


extension DrawingCanvas {
    
}


