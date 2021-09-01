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


#if targetEnvironment(macCatalyst)
    import SwiftUI
    import UIKit
    import Foundation
#else
    import SwiftUI
    import GoogleMobileAds
    import UIKit
    import Foundation
#endif





#if targetEnvironment(macCatalyst)

#else
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



//final class InterstitialVC: UIViewControllerRepresentable{
//
//
//    private var interstitial: GADInterstitialAd?
//
//
//    func makeUIViewController(context: Context) -> some UIViewController {
//
//
//        let viewController = UIViewController()
//
//        let request = GADRequest()
//        let view =
//            GADInterstitialAd.load(withAdUnitID:"ca-app-pub-3940256099942544/4411468910",
//                                        request: request,
//                              completionHandler: { [self] ad, error in
//                                if let error = error {
//                                  print("Failed to load interstitial ad with error: \(error.localizedDescription)")
//                                  return
//                                }
//                                interstitial = ad
//                              }
//            )
//
//        return viewController
//
//
//    }
//
//    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
//
//    }
//
//
//
//    /// Tells the delegate that the ad failed to present full screen content.
//    @objc func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
//       print("Ad did fail to present full screen content.")
//     }
//
//     /// Tells the delegate that the ad presented full screen content.
//    @objc func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
//       print("Ad did present full screen content.")
//     }
//
//     /// Tells the delegate that the ad dismissed full screen content.
//    @objc func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
//       print("Ad did dismiss full screen content.")
//     }
//
//
//}

final class Interstitial:NSObject, GADFullScreenContentDelegate {
  var interstitial:GADInterstitialAd?

  override init() {
    super.init()
    self.loadInterstitial()
  }

    func loadInterstitial(){
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID:"ca-app-pub-3940256099942544/4411468910",
                               request: request,
                               completionHandler: { [self] ad, error in
                                if let error = error {
                                    print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                                    return
                                }
                                interstitial = ad
                                interstitial?.fullScreenContentDelegate = self
                               })
    }

    func showAd(){
        if self.interstitial != nil {
            let root = UIApplication.shared.windows.first?.rootViewController
            self.interstitial?.present(fromRootViewController: root!)
        }
        else{
            print("Not Ready")
        }
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad did dismiss full screen content.")
        self.loadInterstitial()
    }
    
}
#endif



