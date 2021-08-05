//
//  TabColor.swift
//  ToDoToday
//
//  Created by Noe De La Croix on 05/08/2021.
//

import Foundation
import SwiftUI

enum TabColor: String, CaseIterable, Identifiable {
//    case CRed = "red"
//    case CYellow = "yellow"
//    case CPurple = "purple"
//    case CBlue = "blue"
//    case CGreen = "green"
//    case COrange = "orange"
//    case CClear = "clear"
    
    case Amethyst = "amethyst"
    case MagentaCrayola = "magentaCrayola"
    case MinionYellow = "minionYellow"
    case Capri = "capri"
    case SeaGreenCrayola = "seaGreenCrayola"
    
    var id: TabColor {self}
    
    var associatedColor: (UIColor) {
        get {
            switch self {
//            case .CRed: return UIColor.red
//            case .CYellow: return UIColor.yellow
//            case .CPurple: return UIColor.purple
//            case .CBlue: return UIColor.blue
//            case .CGreen: return UIColor.green
//            case .COrange: return UIColor.orange
//            case .CClear: return UIColor.clear
                
            case .Amethyst: return UIColor(hex: "#9b5de5ff")!
            case .MagentaCrayola : return UIColor(hex: "#f15bb5ff")!
            case .MinionYellow: return UIColor(hex: "#fee440ff")!
            case .Capri: return UIColor(hex: "#00bbf9ff")!
            case .SeaGreenCrayola: return UIColor(hex: "#00f5d4ff")!
            }
        }
    }
}

