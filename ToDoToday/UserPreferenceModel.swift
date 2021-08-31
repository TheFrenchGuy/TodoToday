//
//  UserPreferenceModel.swift
//  ToDoToday
//
//  Created by Noe De La Croix on 21/07/2021.
//

import Foundation
import Combine
import UIKit

class UserPreference: ObservableObject {
    @Published var firstlaunch: Bool {
        didSet{
            UserDefaults.standard.set(firstlaunch, forKey: "firstlaunch")
        }
    }
    
    @Published var reminderlist: Int { ///Reminder list 0 is the Calendar type and Reminder list 1 is the Bullet Point
        didSet {
            UserDefaults.standard.set(reminderlist, forKey: "reminderlist")
        }
    }
    
    @Published var alwaysSameList: Bool {
        didSet {
            UserDefaults.standard.set(alwaysSameList, forKey: "alwaysSameList")
        }
    }
    
    @Published var notificationTime: Date {
        didSet {
            UserDefaults.standard.set(notificationTime, forKey: "notificationTime")
        }
    }
    
    @Published var daystoDND: [String] {
        didSet {
            UserDefaults.standard.set(daystoDND, forKey: "daystoDND")
        }
    }
    
    @Published var startWeekDay: String {
        didSet {
            UserDefaults.standard.set(startWeekDay, forKey: "startWeekDay")
        }
    }
    
    @Published var storeCoreDataIcloud: Bool {
        didSet {
            UserDefaults.standard.set(storeCoreDataIcloud, forKey: "storeCoreDataIcloud")
        }
    }
    
    init() {
        self.firstlaunch = UserDefaults.standard.object(forKey: "firstlaunch") as? Bool ?? true
        self.reminderlist = UserDefaults.standard.object(forKey: "reminderlist") as? Int ?? -1
        self.alwaysSameList = UserDefaults.standard.object(forKey: "alwaysSameList") as? Bool ?? false
        self.notificationTime = UserDefaults.standard.object(forKey: "notificationTime") as? Date ?? Date()
        self.daystoDND = UserDefaults.standard.object(forKey: "daystoDND") as? [String] ?? []
        self.startWeekDay = UserDefaults.standard.object(forKey: "startWeekDay") as? String ?? "Mon"
        self.storeCoreDataIcloud = UserDefaults.standard.object(forKey: "storeCoreDataIcloud") as? Bool ?? true
       
    }
}

