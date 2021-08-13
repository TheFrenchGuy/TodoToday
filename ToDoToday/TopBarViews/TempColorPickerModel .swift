//
//  TempColorPickerModel .swift
//  ToDoToday
//
//  Created by Noe De La Croix on 08/08/2021.
//

import Foundation
import SwiftUI
import Combine

class TransferColorPalette: ObservableObject {
//    @Published var title: [String] = []
//    @Published var color: [Color] = []
     @Published var colorpla: [ColorPaletteTemp] = []
}

struct ColorPaletteTemp: Identifiable, Hashable {
    var id: UUID = UUID()
    var title: String = ""
    var color: Color = Color.black
    var isMarked: Bool = false
}
