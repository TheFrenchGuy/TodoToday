//
//  Array Extension.swift
//  ToDoToday
//
//  Created by Noe De La Croix on 27/07/2021.
//

import Foundation

extension Array: Identifiable where Element: Hashable {
   public var id: Self { self }
}
