//
//  DisableModalDismiss.swift
//  ToDoToday
//
//  Created by Noe De La Croix on 21/07/2021.
//

import Foundation
import UIKit
import SwiftUI


struct DisableModalDismiss: ViewModifier { //So in the setup view the sheet cannot be dismissed
    let disabled: Bool
    func body(content: Content) -> some View {
        disableModalDismiss()
        return AnyView(content)
    }

    func disableModalDismiss() {
        guard let visibleController = UIApplication.shared.visibleViewController() else { return }
        visibleController.isModalInPresentation = disabled
    }
}
