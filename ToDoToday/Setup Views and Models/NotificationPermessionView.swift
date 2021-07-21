//
//  NotificationPermessionView.swift
//  ToDoToday
//
//  Created by Noe De La Croix on 21/07/2021.
//

import SwiftUI

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
    
    var literal: String {
        switch self {
        case .Monday: return "Monday"
        case .Tuesday: return "Tuesday"
        case .Wednesday: return "Wednesday"
        case .Thrusday: return "Thrusday"
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
                    
                    Text("Notification Settings, gotta be productive 😎").fontWeight(.bold)
                        .padding(bounds.size.width * 0.05)
                    VStack(alignment: .leading) {
                        HStack {
                            Text("What time would you want to be reminded to add task to your to do list?")
                            Image(systemName: "sunrise")
                        }
                        
                        DatePicker("Time", selection: $date, displayedComponents: .hourAndMinute).onChange(of: date) { newValue in
                            userPreference.notificationTime = date
                            print(userPreference.notificationTime)
                            
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
                                }
                                
                                
                            }
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
                            }
                    }.frame(width: bounds.size.width * 0.8, alignment: .leading)
                        .padding()
                       .background(RoundedRectangle(cornerRadius: 15).opacity(0.15)
                                       .shadow(color: .black.opacity(0.5), radius: 15, x: 10, y: 10))
                    
                }.frame(width: bounds.size.width, height: bounds.size.height)
                 
                 
            }
        }
            .onAppear(perform: requestNotification)
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

