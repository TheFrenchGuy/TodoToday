//
//  SignandCompleteView.swift
//  SignandCompleteView
//
//  Created by Noe De La Croix on 30/08/2021.
//

import SwiftUI
import PencilKit
import UIKit


enum AgreedTermsAndConditionEnum: String, CaseIterable, Identifiable {
    case yes
    case no
    
    var id: String {self.rawValue}
}

struct SignandCompleteView: View {
    @Environment(\.managedObjectContext) private var viewContext


    @FetchRequest(entity: ColorPalette.entity(), sortDescriptors: []) var colorpalette: FetchedResults<ColorPalette>
    
    
    @Environment(\.undoManager) private var undoManager
    @State private var canvasView = PKCanvasView()
    @ObservedObject var userPreference = UserPreference()
    @Binding var completion: Bool
    @Binding var storeInIC: Bool
    
    @State var showingAlert = false
    @State var selectedAnswer = AgreedTermsAndConditionEnum.no
    @State private var showSignatureView = false
    
    var body: some View {
        ZStack {
            GeometryReader { bounds in
                if completion {
                    CompletionView(storeInIC: $storeInIC)
                
                
                } else {
                    
                    
                    VStack {
                        
                        
                        VStack() {
                            Text("Sign and Start").font(.title).bold()
                            Image(systemName: "book.closed").font(.title)
                            
                        }.padding()
                            .padding(.top, 70)
                        
                        
                        VStack(alignment: .leading) {
                                    
                                    Text("Do you agree to the Terms and Conditions ?")
                                    Text("* if you do not agree then you will not be able to use the services").font(.footnote).opacity(0.75)
                                    
                                    Picker("Do you agree to the Terms and Conditions ?", selection: $selectedAnswer) {
                                        Text("Yes").tag(AgreedTermsAndConditionEnum.yes)
                                        Text("No").tag(AgreedTermsAndConditionEnum.no)
                                    }.pickerStyle(SegmentedPickerStyle())
                                }.frame(width: bounds.size.width * 0.8)
                            .padding()
                           .background(RoundedRectangle(cornerRadius: 15).opacity(0.15)
                                           .shadow(color: .black.opacity(0.5), radius: 15, x: 10, y: 10))
                           .padding(.bottom, 40)
                        
                        
                            VStack(alignment: .center){
                                       
                                
                                    if UIDevice.current.userInterfaceIdiom == .pad {
                                            ZStack() {
                                                SignCanvas(canvasView: $canvasView).frame(width:bounds.size.width * 0.7, height: bounds.size.height * 0.2)
                                                Text("Sign here").font(.title).foregroundColor(.gray)
                                            }.background(Rectangle().stroke(Color.gray, lineWidth: 6))
                                        
                                            Button(action: { undoManager?.undo()}) { Text("Undo").foregroundColor(.gray)
                                                .padding(10).background(RoundedRectangle(cornerRadius: 20).stroke(Color.gray, lineWidth: 2))}
                                    }
                                
                                       
                                        if #available(iOS 15.0, *) {
                                            Button(action: {
                                                if colorpalette.isEmpty == false && selectedAnswer == AgreedTermsAndConditionEnum.yes {
                                                    SaveSignature()
                                                    completion.toggle()
                                                } else {
                                                    showingAlert.toggle()
                                                }
            
                                            }) {
                                                VStack(alignment: .center) {
                                                    Text("Ready to Elevate your To Do List?").bold().padding(.bottom, 35)
                                                    
                                                    Image("Rocket-100px").renderingMode(.template)
                                                        .frame(width: 10, height: 10)
                                                        //.scaledToFit()
                                                        
                                                    
                                                }.foregroundColor(.blue)
                                            }.padding()
                                                
                                                .alert(isPresented: $showingAlert) {
                                                    Alert(title: Text("Please fill in all the necessary fields"))
                                                }
                                        } else {
                                            Button(action: {
                                                if colorpalette.isEmpty == false && selectedAnswer == AgreedTermsAndConditionEnum.yes{
                                                    SaveSignature()
                                                    completion.toggle()
                                                } else {
                                                    showingAlert.toggle()
                                                }
            
                                            }) {
                                                
                                                VStack(alignment: .center) {
                                                    Text("Ready to Elevate your To Do List?").bold().padding(.bottom, 35)
                                                    
                                                    Image("Rocket-100px").renderingMode(.template)
                                                        .frame(width: 10, height: 10)
                                                        //.scaledToFit()
                                                        
                                                    
                                                }.foregroundColor(.blue)
                                            }.padding()

                                                .alert(isPresented: $showingAlert, content: {
                                                    Alert(title: Text ("Not filled all in"), message: Text("Please fill all the fields in"), dismissButton: .default(Text("Okay")))
                                                })
                                        }
                                    }.padding()
                        
                        Spacer()
                        
                    }.frame(width: bounds.size.width, height: bounds.size.height, alignment: .center)
                        }
                }
        }
    }
    
    func SaveSignature() {
        let image = canvasView.drawing.image(from: canvasView.drawing.bounds, scale: 1)
        let imageData = image.jpegData(compressionQuality: 1.0)
        UserDefaults().set(imageData, forKey: "signatureImage")
        
    }
}

//struct SignandCompleteView_Previews: PreviewProvider {
//    static var previews: some View {
//        SignandCompleteView()
//    }
//}
