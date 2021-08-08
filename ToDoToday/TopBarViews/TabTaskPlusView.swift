//
//  TabTaskPlusView.swift
//  ToDoToday
//
//  Created by Noe De La Croix on 07/08/2021.
//

import SwiftUI

struct TabTaskPlusView: View {
    
    @EnvironmentObject var tabViewClass:TabViewClass
    
    var body: some View {
        
        
            HStack {
                
                Button(action: {
                    
                    toggleTabView()
                }) {
                    
                    if self.tabViewClass.showTab {
                        ZStack {
                            RoundedRectangle(cornerRadius: 6).foregroundColor(.blue).frame(width: 35, height: 35, alignment: .center)
                            Image(systemName: "sidebar.left").font(.title2).foregroundColor(.white)
                        }
                    } else {
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 6).foregroundColor(.blue).frame(width: 35, height: 35, alignment: .center).opacity(0.0)
                            Image(systemName: "sidebar.left").font(.title2)
                        }
                    }
                }.background(
                    GeometryReader { proxy in
                        Color.clear
                           .preference(
                               key: SizePreferenceKey.self,
                               value: proxy.size
                            )
                    }
                )
                .contentShape(Rectangle())

                
                Button(action: {
                    toggleTaskView()
                }) {
                    
                    if self.tabViewClass.showTask {
                        ZStack {
                            RoundedRectangle(cornerRadius: 6).foregroundColor(.blue).frame(width: 35, height: 35, alignment: .center)
                            Image(systemName: "archivebox").font(.title2).foregroundColor(.white)
                        }
                        
                    } else {
                        ZStack {
                            RoundedRectangle(cornerRadius: 6).foregroundColor(.blue).frame(width: 35, height: 35, alignment: .center).opacity(0.0)
                            Image(systemName: "archivebox").font(.title2)
                        }
                    }
                }
                
                Button(action: {
                    self.tabViewClass.addNewTask.toggle()
                }) {
                    Image(systemName: "plus").font(.title2)
                }
                
               
            
            
            
            
        }
            
        
        
            
    }
    
    func toggleTabView() {
        self.tabViewClass.showTab.toggle()
        
        if self.tabViewClass.showTask == true {
            self.tabViewClass.showTask.toggle()
        }
    }
    
    func toggleTaskView() {
        self.tabViewClass.showTask.toggle()
        
        if self.tabViewClass.showTab == true {
            self.tabViewClass.showTab.toggle()
        }
    }
}


struct NavBarAccessor: UIViewControllerRepresentable {
    var callback: (UINavigationBar) -> Void
    private let proxyController = ViewController()

    func makeUIViewController(context: UIViewControllerRepresentableContext<NavBarAccessor>) ->
                              UIViewController {
        proxyController.callback = callback
        return proxyController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<NavBarAccessor>) {
    }

    typealias UIViewControllerType = UIViewController

    private class ViewController: UIViewController {
        var callback: (UINavigationBar) -> Void = { _ in }

        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            if let navBar = self.navigationController {
                self.callback(navBar.navigationBar)
            }
        }
    }
}



//struct TabTaskPlusView_Previews: PreviewProvider {
//    static var previews: some View {
//        TabTaskPlusView()
//    }
//}

struct SizePreferenceKey: PreferenceKey {
    typealias Value = CGSize
    static var defaultValue: Value = .zero

    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = nextValue()
    }
}
