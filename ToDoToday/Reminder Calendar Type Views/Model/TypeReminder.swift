//
//  TypeReminder.swift
//  ToDoToday
//
//  Created by Noe De La Croix on 29/07/2021.
//

import Foundation
import SwiftUI


enum TypeReminder: String, CaseIterable, Identifiable {
    case drawing = "Drawing"
    case typed = "Typed"
    case image = "Image"
    case audio = "Audio"
    
    var id: TypeReminder {self}
}


enum TabColor: String, CaseIterable, Identifiable {
    case CRed = "red"
    case CYellow = "yellow"
    case CPurple = "purple"
    case CBlue = "blue"
    case CGreen = "green"
    case COrange = "orange"
    case CClear = "clear"
    
    var id: TabColor {self}
    
    var associatedColor: (UIColor) {
        get {
            switch self {
            case .CRed: return UIColor.red
            case .CYellow: return UIColor.yellow
            case .CPurple: return UIColor.purple
            case .CBlue: return UIColor.blue
            case .CGreen: return UIColor.green
            case .COrange: return UIColor.orange
            case .CClear: return UIColor.clear
            }
        }
    }
}
