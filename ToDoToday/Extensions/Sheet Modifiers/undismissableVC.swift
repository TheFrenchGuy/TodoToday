//
//  undismissableVC.swift
//  ToDoToday
//
//  Created by Noe De La Croix on 21/07/2021.
//

import Foundation
import UIKit

extension UIApplication { //Neccesary for the view sheet so that it cannot be dismissed
    func visibleViewController() -> UIViewController? {
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return nil }
        guard let rootViewController = window.rootViewController else { return nil }
        return UIApplication.getVisibleViewControllerFrom(vc: rootViewController)
    }

    private static func getVisibleViewControllerFrom(vc:UIViewController) -> UIViewController {
        if let navigationController = vc as? UINavigationController,
            let visibleController = navigationController.visibleViewController  {
            return UIApplication.getVisibleViewControllerFrom( vc: visibleController )
        } else if let tabBarController = vc as? UITabBarController,
            let selectedTabController = tabBarController.selectedViewController {
            return UIApplication.getVisibleViewControllerFrom(vc: selectedTabController )
        } else {
            if let presentedViewController = vc.presentedViewController {
                return UIApplication.getVisibleViewControllerFrom(vc: presentedViewController)
            } else {
                return vc
            }
        }
    }
}
