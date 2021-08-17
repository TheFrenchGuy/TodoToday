//
//  TermsandConditionView.swift
//  ToDoToday
//
//  Created by Noe De La Croix on 21/07/2021.
//


import SwiftUI
import PencilKit
import UIKit
struct TermsandConditionView: View {
    
    @Environment(\.managedObjectContext) private var viewContext


    @FetchRequest(entity: ColorPalette.entity(), sortDescriptors: []) var colorpalette: FetchedResults<ColorPalette>
    
    
    @Environment(\.undoManager) private var undoManager
    @State private var canvasView = PKCanvasView()
    @ObservedObject var userPreference = UserPreference()
    @Binding var completion: Bool
    @State var showingAlert = false
    var body: some View {
        ZStack() {
            GeometryReader {bounds in
                
                if completion {
                    CompletionView()
                } else {
                    VStack {
                        VStack() {
                            Text("Boring legal stuff").font(.largeTitle).bold()
                            Image(systemName: "signature").font(.largeTitle)
                            
                        }
                        
                        Divider().frame(width: bounds.size.width * 0.8)
                        
                        ScrollView(.vertical) {
                            Text(termsandcondition)
                        }.frame(width: bounds.size.width * 0.8, height: bounds.size.height * 0.6)
                        
                        Divider().frame(width: bounds.size.width * 0.8)
                        
                        HStack(alignment: .top){
                            Button(action: { undoManager?.undo()}) { Text("Undo").foregroundColor(.gray)
                                .padding(10).background(RoundedRectangle(cornerRadius: 20).stroke(Color.gray, lineWidth: 2))}
                            ZStack() {
                                SignCanvas(canvasView: $canvasView).frame(width:bounds.size.width * 0.5, height: bounds.size.height * 0.2)
                                Text("Sign here").font(.title).foregroundColor(.gray)
                            }.background(Rectangle().stroke(Color.gray, lineWidth: 6))
                            if #available(iOS 15.0, *) {
                                Button(action: {
                                    if userPreference.reminderlist != -1 {
                                        SaveSignature()
                                        completion.toggle()
                                    } else {
                                        showingAlert.toggle()
                                    }
                                    
                                }) {
                                    Image(systemName: "arrow.forward.circle").foregroundColor(.black).font(.largeTitle)
                                }.padding()
                                    .frame(height: bounds.size.height * 0.2)
                                    .alert(isPresented: $showingAlert) {
                                        Alert(title: Text("Please fill in all the necessary fields"))
                                    }
                            } else {
                                Button(action: {
                                    if userPreference.reminderlist != -1 && !colorpalette.isEmpty{
                                        SaveSignature()
                                        completion.toggle()
                                    } else {
                                        showingAlert.toggle()
                                    }
                                    
                                }) {
                                    Image(systemName: "arrow.forward.circle").foregroundColor(.black).font(.largeTitle)
                                }.padding()
                                    .frame(height: bounds.size.height * 0.2)
                                    .alert(isPresented: $showingAlert, content: {
                                        Alert(title: Text ("Not filled all in"), message: Text("Please fill all the fields in"), dismissButton: .default(Text("Okay")))
                                    })
                            }
                        }.padding()
                    }.frame(width: bounds.size.width, height: bounds.size.height)
                    
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

var termsandcondition = """
Welcome to todotoday!
These terms and conditions outline the rules and regulations for the use of TodoToday's Website, located at todotoday.com.
By accessing this website we assume you accept these terms and conditions. Do not continue to use todotoday if you do not agree to take all of the terms and conditions stated on this page.
The following terminology applies to these Terms and Conditions, Privacy Statement and Disclaimer Notice and all Agreements: "Client", "You" and "Your" refers to you, the person log on this website and compliant to the Company’s terms and conditions. "The Company", "Ourselves", "We", "Our" and "Us", refers to our Company. "Party", "Parties", or "Us", refers to both the Client and ourselves. All terms refer to the offer, acceptance and consideration of payment necessary to undertake the process of our assistance to the Client in the most appropriate manner for the express purpose of meeting the Client’s needs in respect of provision of the Company’s stated services, in accordance with and subject to, prevailing law of Netherlands. Any use of the above terminology or other words in the singular, plural, capitalization and/or he/she or they, are taken as interchangeable and therefore as referring to same.
Cookies
We employ the use of cookies. By accessing todotoday, you agreed to use cookies in agreement with the TodoToday's Privacy Policy.
Most interactive websites use cookies to let us retrieve the user’s details for each visit. Cookies are used by our website to enable the functionality of certain areas to make it easier for people visiting our website. Some of our affiliate/advertising partners may also use cookies.
License
Unless otherwise stated, TodoToday and/or its licensors own the intellectual property rights for all material on todotoday. All intellectual property rights are reserved. You may access this from todotoday for your own personal use subjected to restrictions set in these terms and conditions.
You must not:
    •    Republish material from todotoday
    •    Sell, rent or sub-license material from todotoday
    •    Reproduce, duplicate or copy material from todotoday
    •    Redistribute content from todotoday
This Agreement shall begin on the date hereof. Our Terms and Conditions were created with the help of the Terms And Conditions Generator.
Parts of this website offer an opportunity for users to post and exchange opinions and information in certain areas of the website. TodoToday does not filter, edit, publish or review Comments prior to their presence on the website. Comments do not reflect the views and opinions of TodoToday,its agents and/or affiliates. Comments reflect the views and opinions of the person who post their views and opinions. To the extent permitted by applicable laws, TodoToday shall not be liable for the Comments or for any liability, damages or expenses caused and/or suffered as a result of any use of and/or posting of and/or appearance of the Comments on this website.
TodoToday reserves the right to monitor all Comments and to remove any Comments which can be considered inappropriate, offensive or causes breach of these Terms and Conditions.
You warrant and represent that:
    •    You are entitled to post the Comments on our website and have all necessary licenses and consents to do so;
    •    The Comments do not invade any intellectual property right, including without limitation copyright, patent or trademark of any third party;
    •    The Comments do not contain any defamatory, libelous, offensive, indecent or otherwise unlawful material which is an invasion of privacy
    •    The Comments will not be used to solicit or promote business or custom or present commercial activities or unlawful activity.
You hereby grant TodoToday a non-exclusive license to use, reproduce, edit and authorize others to use, reproduce and edit any of your Comments in any and all forms, formats or media.
Hyperlinking to our Content
The following organizations may link to our Website without prior written approval:
    •    Government agencies;
    •    Search engines;
    •    News organizations;
    •    Online directory distributors may link to our Website in the same manner as they hyperlink to the Websites of other listed businesses; and
    •    System wide Accredited Businesses except soliciting non-profit organizations, charity shopping malls, and charity fundraising groups which may not hyperlink to our Web site.
These organizations may link to our home page, to publications or to other Website information so long as the link: (a) is not in any way deceptive; (b) does not falsely imply sponsorship, endorsement or approval of the linking party and its products and/or services; and (c) fits within the context of the linking party’s site.
We may consider and approve other link requests from the following types of organizations:
    •    commonly-known consumer and/or business information sources;
    •    dot.com community sites;
    •    associations or other groups representing charities;
    •    online directory distributors;
    •    internet portals;
    •    accounting, law and consulting firms; and
    •    educational institutions and trade associations.
We will approve link requests from these organizations if we decide that: (a) the link would not make us look unfavorably to ourselves or to our accredited businesses; (b) the organization does not have any negative records with us; (c) the benefit to us from the visibility of the hyperlink compensates the absence of TodoToday; and (d) the link is in the context of general resource information.
These organizations may link to our home page so long as the link: (a) is not in any way deceptive; (b) does not falsely imply sponsorship, endorsement or approval of the linking party and its products or services; and (c) fits within the context of the linking party’s site.
If you are one of the organizations listed in paragraph 2 above and are interested in linking to our website, you must inform us by sending an e-mail to TodoToday. Please include your name, your organization name, contact information as well as the URL of your site, a list of any URLs from which you intend to link to our Website, and a list of the URLs on our site to which you would like to link. Wait 2-3 weeks for a response.
Approved organizations may hyperlink to our Website as follows:
    •    By use of our corporate name; or
    •    By use of the uniform resource locator being linked to; or
    •    By use of any other description of our Website being linked to that makes sense within the context and format of content on the linking party’s site.
No use of TodoToday's logo or other artwork will be allowed for linking absent a trademark license agreement.
iFrames
Without prior approval and written permission, you may not create frames around our Webpages that alter in any way the visual presentation or appearance of our Website.
Content Liability
We shall not be hold responsible for any content that appears on your Website. You agree to protect and defend us against all claims that is rising on your Website. No link(s) should appear on any Website that may be interpreted as libelous, obscene or criminal, or which infringes, otherwise violates, or advocates the infringement or other violation of, any third party rights.
Your Privacy
Please read Privacy Policy
Reservation of Rights
We reserve the right to request that you remove all links or any particular link to our Website. You approve to immediately remove all links to our Website upon request. We also reserve the right to amen these terms and conditions and it’s linking policy at any time. By continuously linking to our Website, you agree to be bound to and follow these linking terms and conditions.
Removal of links from our website
If you find any link on our Website that is offensive for any reason, you are free to contact and inform us any moment. We will consider requests to remove links but we are not obligated to or so or to respond to you directly.
We do not ensure that the information on this website is correct, we do not warrant its completeness or accuracy; nor do we promise to ensure that the website remains available or that the material on the website is kept up to date.
Disclaimer
To the maximum extent permitted by applicable law, we exclude all representations, warranties and conditions relating to our website and the use of this website. Nothing in this disclaimer will:
    •    limit or exclude our or your liability for death or personal injury;
    •    limit or exclude our or your liability for fraud or fraudulent misrepresentation;
    •    limit any of our or your liabilities in any way that is not permitted under applicable law; or
    •    exclude any of our or your liabilities that may not be excluded under applicable law.
The limitations and prohibitions of liability set in this Section and elsewhere in this disclaimer: (a) are subject to the preceding paragraph; and (b) govern all liabilities arising under the disclaimer, including liabilities arising in contract, in tort and for breach of statutory duty.
As long as the website and the information and services on the website are provided free of charge, we will not be liable for any loss or damage of any nature.
"""



struct SignCanvas: UIViewRepresentable {
    @Binding var canvasView: PKCanvasView

    func makeUIView(context: Context) -> PKCanvasView {
        canvasView.drawingPolicy = .anyInput
        canvasView.tool = PKInkingTool(.pen, color: .black, width: 15)
        return canvasView
    }

    func updateUIView(_ canvasView: PKCanvasView, context: Context) { }
}

struct CompletionView: View {
    var body: some View {
        Text ("Completed").onAppear(perform: {
            UserDefaults.standard.set(false, forKey: "firstlaunch") // This means that the user is logging in the first time so he must complete the daily intake calculator
            NotificationCenter.default.post(name: NSNotification.Name("firstlaunch"), object: nil) //Put a backend notification to inform app the data has been written
        })
        
        
    }
}

