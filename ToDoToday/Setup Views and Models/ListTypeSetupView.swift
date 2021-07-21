//
//  ListTypeSetupView.swift
//  ToDoToday
//
//  Created by Noe De La Croix on 21/07/2021.
//

import SwiftUI

struct ListTypeSetupView: View {
    @State private var showcheck1 = false
    @State private var showcheck2 = false
    @State private var completed = false
    @ObservedObject var userPreference = UserPreference()
    var body: some View {
        if !completed {
        TabView() {
            ZStack(alignment: .center){
               
                GeometryReader { bounds in
                    VStack(alignment: .center) {
                        Text("What type of todo list you want to have").fontWeight(.bold)
                            .padding(bounds.size.width * 0.05)
                        VStack {
                            
                            HStack(alignment: .center) {
                            Button(action: {
                                self.showcheck1 = true
                                self.showcheck2 = false
                                self.userPreference.reminderlist = 1
                            }) {
                                Text("Bullet Point").padding(.horizontal)
                                    .padding(.leading, bounds.size.width * 0.03)
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                                    .opacity(self.showcheck1 ? 1 : 0 )
                                
                            }.foregroundColor(.black)
                            .padding()
                                
                            }
                            
                            Divider()
                            HStack(alignment: .center) {
                                Button(action: {
                                    self.showcheck1 = false
                                    self.showcheck2 = true
                                    self.userPreference.reminderlist = 0
                                }) {
                                    Text("Calendar Type").padding(.horizontal)
                                        .padding(.leading, bounds.size.width * 0.03)
                                        
                                    
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue)
                                        .opacity(self.showcheck2 ? 1 : 0 )
                                }.foregroundColor(.black)
                                .padding()
                                
                                
                            }
                        }.background(RoundedRectangle(cornerRadius: 15).opacity(0.15))
                        .frame(width: bounds.size.width * 0.5)
                        .shadow(color: .black.opacity(0.5), radius: 15, x: 10, y: 10)
                        .padding()
                            ZStack() {
                                
                                HStack(alignment: .center) {
                                    
                                    Toggle("Do you want it to always remeber that setting", isOn: $userPreference.alwaysSameList)
                                        
                                }.padding()
                                    .zIndex(1)
                                RoundedRectangle(cornerRadius: 15).opacity(0.15)
                                    .shadow(color: .black.opacity(0.5), radius: 15, x: 10, y: 10)
                                    .zIndex(0)
                                
                                    .frame(height: bounds.size.height * 0.1)
                            }   .frame(width: bounds.size.width * 0.5)
                                .padding()
                        
                        Text("* You will be able to change it later").foregroundColor(.gray).font(.subheadline).padding(.trailing, bounds.size.width * 0.3)
                            .padding(.bottom, 70)
                        
                        
                        
                        
                        Image("ToDoTodaySetupCardImage").resizable().scaledToFit().frame(width: bounds.size.width * 0.15)
                            .padding(.bottom, bounds.size.height * 0.05)
                        
                        
                    }.frame(width: bounds.size.width, height: bounds.size.height)
                }
            }
            
            NotificationPermessionView()
            
            iCloudSyncView()
            
            TermsandConditionView(completion: $completed)
            
        
            
            
        }.tabViewStyle(PageTabViewStyle()) //Page scrolling view
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always)) //Show the number of tabs there is
        } else {
            CompletionView()
        }
    }
}

//2
//struct ListTypeSetupView_Previews: PreviewProvider {
//    static var previews: some View {
//        if #available(iOS 15.0, *) {
//            ListTypeSetupView()
//                .previewInterfaceOrientation(.landscapeLeft)
//        } else {
//            // Fallback on earlier versions
//        }
//    }
//}

