//
//  Interstitial.swift
//  Interstitial
//
//  Created by Noe De La Croix on 01/09/2021.
//
//import Foundation
//import SwiftUI
//import GoogleMobileAds
//import UIKit

//final class Interstitial:NSObject, GADInterstitialDelegate{
//    var interstitial:GADInterstitial = GADInterstitial(adUnitID: "ca-app-pub-6731654549015895/2725227612")
//
//    override init() {
//        super.init()
//        LoadInterstitial()
//    }
//
//    func LoadInterstitial(){
//        let req = GADRequest()
//        self.interstitial.load(req)
//        self.interstitial.delegate = self
//    }
//
//    func showAd(){
//        if self.interstitial.isReady{
//           let root = UIApplication.shared.windows.first?.rootViewController
//           self.interstitial.present(fromRootViewController: root!)
//        }
//       else{
//           print("Not Ready")
//       }
//    }
//
//    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
//        self.interstitial = GADInterstitial(adUnitID: "ca-app-pub-6731654549015895/2725227612")
//        LoadInterstitial()
//    }
//}
import SwiftUI
import GoogleMobileAds
import UIKit

final class BannerVC: UIViewControllerRepresentable  {

    func makeUIViewController(context: Context) -> UIViewController {
        let view = GADBannerView(adSize: kGADAdSizeBanner)

        let viewController = UIViewController()
        view.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        view.rootViewController = viewController
        viewController.view.addSubview(view)
        viewController.view.frame = CGRect(origin: .zero, size: kGADAdSizeBanner.size)
        view.load(GADRequest())

        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
//


struct BannerView: View {
    var body: some View {
        BannerVC()
    }
}

