//
//  TypeReminder.swift
//  ToDoToday
//
//  Created by Noe De La Croix on 29/07/2021.
//

import Foundation


enum TypeReminder: String, CaseIterable, Identifiable {
    case drawing = "Drawing"
    case typed = "Typed"
    case image = "Image"
    case audio = "Audio"
    
    var id: TypeReminder {self}
}
