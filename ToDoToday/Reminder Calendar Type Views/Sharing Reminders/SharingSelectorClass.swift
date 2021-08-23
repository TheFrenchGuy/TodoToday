//
//  SharingSelectorClass.swift
//  ToDoToday
//
//  Created by Noe De La Croix on 23/08/2021.
//

import Foundation

class showActivityShareSelector: ObservableObject {
    @Published var drawing: Bool = false
    @Published var text: Bool = false
    @Published var image: Bool = false
    @Published var audio: Bool = false
}
