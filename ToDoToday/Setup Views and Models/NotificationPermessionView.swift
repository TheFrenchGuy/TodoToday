//
//  NotificationPermessionView.swift
//  ToDoToday
//
//  Created by Noe De La Croix on 21/07/2021.
//

import SwiftUI
import UserNotifications
import CoreData
import Combine

enum DaysOfWeek: Int, CaseIterable, Identifiable {
    case Monday = 0
    case Tuesday
    case Wednesday
    case Thrusday
    case Friday
    case Saturday
    case Sunday
    
    var id: DaysOfWeek {
        self
    }
    
    var literal: String{
        switch self {
        case .Monday: return "Monday"
        case .Tuesday: return "Tuesday"
        case .Wednesday: return "Wednesday"
        case .Thrusday: return "Thursday"
        case .Friday: return "Friday"
        case .Saturday: return "Saturday"
        case .Sunday: return "Sunday"
        
            
        }
    }
}

enum DayStart: String, CaseIterable, Identifiable {
    case Mon
    case Tue
    case Wed
    case Thru
    case Fri
    case Sat
    case Sun
    var id: String{ self.rawValue }
    
}


class DaysDND: ObservableObject {
    @Published var daysDND = [DaysOfWeek]()
}

struct NotificationPermessionView: View {
    
    @Environment(\.managedObjectContext) private var viewContext


    @FetchRequest(entity: NotificationsDays.entity(), sortDescriptors: []) var notificationsDays: FetchedResults<NotificationsDays>
    
    @State private var date: Date = (Calendar.current.date(bySettingHour: 7, minute: 0, second: 0 , of: Date())!)
    
    @State private var selectedStartDay = DayStart.Mon
    @State var test = DateComponents()
    @ObservedObject var userPreference = UserPreference()
    @ObservedObject var daysDND = DaysDND()
    @State private var selection = false
    var body: some View {
        ZStack(alignment: .center) {
            GeometryReader { bounds in
                VStack(alignment: .center) {
                    
                    
                    VStack {
                        Text("Notification Settings").font(.title).bold()
                        Image(systemName: "bell.badge").font(.title)
                    }
//                        .padding(bounds.size.width * 0.05)
                        .padding()
                         .padding(.top, 70)
                    VStack(alignment: .leading) {
                        HStack {
                            Text("What time would you want to be reminded to add task to your to do list?")
                            Image(systemName: "sunrise")
                        }
                        
                        DatePicker("Time", selection: $date, displayedComponents: .hourAndMinute).onChange(of: date) { newValue in
                            userPreference.notificationTime = date
                            print(userPreference.notificationTime)
                            editStartNotificationsDays()
                            
                        }
                        
                        
                    }.frame(width: bounds.size.width * 0.8)
                     .padding()
                    .background(RoundedRectangle(cornerRadius: 15).opacity(0.15)
                                    .shadow(color: .black.opacity(0.5), radius: 15, x: 10, y: 10))
                    .padding(.bottom, 40)
                    
                    
                    VStack(alignment: .leading) {
                        Text("Days where you dont want to be disturbed (e.g weekend)")
                        
                        HStack() {
                            Button(action: {
                                selection = true
                            }) {
                                Text("Select")

                                Image(systemName: "chevron.right")
                                
                            }
                        }.frame(width: bounds.size.width * 0.7, alignment: .trailing)
                            .padding()
                            
                            .background(RoundedRectangle(cornerRadius: 15).colorInvert())
                                            
                        .foregroundColor(.black)
                        Text("Days you wont be bothered")
                        
                        if daysDND.daysDND.count != 0{
                            HStack() {
                                ForEach(daysDND.daysDND) { day in
                                    Text("\(day)" as String) ///Works only when you forcast it for some reasons https://stackoverflow.com/questions/62625816/instance-method-appendinterpolation-requires-that-decimal-conform-to-forma
                                    
                                    
                                   
                                }
                            }.onAppear() {
                                userPreference.daystoDND.removeAll()
                                for day in daysDND.daysDND {
                                    userPreference.daystoDND.append("\(day)" as String)
                                    editDNDNotificationsDays()
                                    print("RUNNED")
                                }
                                
                                
                            }
//                            
                            .frame(width: bounds.size.width * 0.7, alignment: .leading)
                                .padding()
                                
                                .background(RoundedRectangle(cornerRadius: 15).colorInvert())
                        }
                        
                       
                    }.sheet(isPresented: self.$selection) {
                        SettingsDaysDNDPickerView(self.daysDND)
                    }
                    .frame(width: bounds.size.width * 0.8)
                        .padding()
                       .background(RoundedRectangle(cornerRadius: 15).opacity(0.15)
                                       .shadow(color: .black.opacity(0.5), radius: 15, x: 10, y: 10))
                    
                    
                    VStack(alignment: .leading) {
                        Text("On what day does your work week start")
                        
                        Text("* This will be used so you can set weekly goals at the start of the week").font(.footnote).opacity(0.75)
                        
                        Picker("Day", selection: self.$selectedStartDay) {
                            ForEach(DayStart.allCases){ day in
                                Text(day.rawValue).tag(day)
                            }
                        }.pickerStyle(SegmentedPickerStyle())
                            .onChange(of: selectedStartDay) { newValue in  self.userPreference.startWeekDay = self.selectedStartDay.rawValue
                                print("The start of the week is set to be \(self.userPreference.startWeekDay)")
                                editStartWeekNotificationDay()
                            }
                    }.frame(width: bounds.size.width * 0.8, alignment: .leading)
                        .padding()
                       .background(RoundedRectangle(cornerRadius: 15).opacity(0.15)
                                       .shadow(color: .black.opacity(0.5), radius: 15, x: 10, y: 10))
                    
                    Spacer()
                    
                }.frame(width: bounds.size.width, height: bounds.size.height, alignment: .center)
                 
                 
            }
        }
        
        .onAppear(perform: {
            requestNotification()
            
            
            
            
            if notificationsDays.isEmpty {
                for day in DaysOfWeek.allCases {
                    let notification = NotificationsDays(context: viewContext)
                    
                    if day.literal == "Monday" {
                        notification.startOfWeek = true
                    } else {
                        notification.startOfWeek = false
                    }
                    notification.day = day.literal
                    notification.id = UUID()
                    
                    
                    
                    notification.shouldBeAlerted = true
                    
//                    for dayDND in daysDND.daysDND {
//                        if dayDND.literal == day.literal { notification.shouldBeAlerted = false
                    //
//                        } else {
//                            notification.shouldBeAlerted = true
//                        }
//                    }
                    
                    print("Should be alerted: \(notification.shouldBeAlerted)")
                    
                    
                    
                    var dateInfo = DateComponents()
                    
//                    (Calendar.current.date(bySettingHour: 7, minute: 0, second: 0 , of: Date())!)
                    switch notification.day {
                        case "Monday":
                            notification.time = date
                        case "Tuesday":
                            notification.time = date
                        case "Wednesday":
                            notification.time = date
                        case "Thursday":
                            notification.time = date
                        case "Friday":
                            notification.time = date
                        case "Saturday":
                            notification.time = date
                        case "Sunday":
                            notification.time = date
                        default:
                            dateInfo.weekday = -1
                    }
                    
                    
                    do {
                        try viewContext.save()
                        print("Saved \(day.literal)")
                    }
                    catch {
                        print(error)
                        print("ERROR COULDN'T ADD DAY")
                    }
                    
                }
            } else {
                for day in DaysOfWeek.allCases{
                    for notification in notificationsDays {
                        print("count \(day)")
                
                
                        if day.literal == notification.day! {
                            print("Value found")
                        }
                        
                    }
                }
            }
        })
    }
    
    
    func editDNDNotificationsDays() {
        for day in DaysOfWeek.allCases {
            for notification in notificationsDays {
                if day.literal == notification.day {
                    for dayDND in daysDND.daysDND {
                        if dayDND.literal == notification.day {
                            notification.shouldBeAlerted = false
                            do {
                                try viewContext.save()
                                print("On \(notification.day) you will be distrubed \(notification.shouldBeAlerted)")
                            } catch {
                                print("Error")
                            }
                        }
                    }
                }
                    
            }
        }
    }
    
    
    func editStartWeekNotificationDay() {
        for notification in notificationsDays {
            if selectedStartDay.rawValue == notification.day {
                notification.startOfWeek = true
            } else {
                notification.startOfWeek = false
            }
            
            do {
                try viewContext.save()
            } catch {
                print(error)
            }
        }
    }
    
    func editStartNotificationsDays() {
        for notification in notificationsDays {
            notification.time = date
            do {
                try viewContext.save()
                print("Start of time : \(date)")
            } catch {
                print(error)
                print("ERROR")
            }
        }
    }
    
    func requestNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("All set!")
               
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}




struct MultipleSelectionRow: View {
    var title: String
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: self.action) {
            HStack {
                Text(self.title)
                if self.isSelected {
                    Spacer()
                    Image(systemName: "checkmark").foregroundColor(.blue)
                }
            }
        }.foregroundColor(Color.black)
    }
}

struct SettingsDaysDNDPickerView: View {
    @State private var selections = [DaysOfWeek]()

    @ObservedObject var daysDND: DaysDND

    init(_ daysDND: DaysDND) {
        self.daysDND = daysDND
    }

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Days where you wont be bothered for not working")) {
                    ForEach(DaysOfWeek.allCases) { item in
                        MultipleSelectionRow(title: item.literal, isSelected: self.selections.contains(item)) {
                            if self.selections.contains(item) {
                                self.selections.removeAll(where: { $0 == item })
                            }
                            else {
                                self.selections.append(item)
                            }
                        }
                    }

                }
            }
            .onAppear(perform: { self.selections = self.daysDND.daysDND})
            .listStyle(GroupedListStyle())
            .navigationBarTitle("DND Days", displayMode: .inline)
            .navigationBarItems(trailing:
                Button(action: {
                    self.daysDND.daysDND = self.selections
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("OK")
                }
            )
        }
    }
}

//struct NotificationPermessionView_Previews: PreviewProvider {
//    static var previews: some View {
//        if #available(iOS 15.0, *) {
//            NotificationPermessionView()
//              //  .previewInterfaceOrientation(.landscapeRight)
//        } else {
//            NotificationPermessionView()
//        }
//    }
//}

