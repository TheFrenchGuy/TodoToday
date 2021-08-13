//
//  ColorPalette+CoreDataProperties.swift
//  ToDoToday
//
//  Created by Noe De La Croix on 05/08/2021.
//
//

import Foundation
import CoreData


extension ColorPalette {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ColorPalette> {
        return NSFetchRequest<ColorPalette>(entityName: "ColorPalette")
    }

    @NSManaged public var name: String?
    @NSManaged public var id: UUID?
    @NSManaged public var paletteColor: SerializableColor?
    @NSManaged public var isSecret: Bool
    @NSManaged public var isMarked: Bool

}

extension ColorPalette : Identifiable {

}
