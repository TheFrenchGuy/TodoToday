//
//  TodaySettingsView.swift
//  ToDoToday
//
//  Created by Noe De La Croix on 07/08/2021.
//

import SwiftUI

struct TodaySettingsView: View {
    var body: some View {
        HStack {
            Button(action: {//MARK: will then implement the settings from there
                
            }) {
                Image(systemName: "umbrella").foregroundColor(.gray).font(.title2).padding()
            }
                
            Divider()
            ShowTodayDateView()
        }
    }
}

struct TodaySettingsView_Previews: PreviewProvider {
    static var previews: some View {
        TodaySettingsView()
    }
}
