//
//  BluffForgeMoreViewController.swift
//  DrawDeckBluffForge
//
//  Created by jin fu on 2024/11/24.
//

import UIKit
import StoreKit

class BluffForgeMoreViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func shareApp(_ sender: Any) {
        let textToShare = "Check out this amazing Fun App - DrawDeck BluffForge!"
        let imageToShare = UIImage(named: "ic_appIcon")
        let itemsToShare: [Any] = [textToShare, imageToShare as Any]
        let activityViewController = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
        activityViewController.excludedActivityTypes = [
            .postToFacebook,
            .postToTwitter,
            .message
        ]
        present(activityViewController, animated: true, completion: nil)
    }
    
    
    @IBAction func rateUs(_ sender: Any) {
        if let scene = view.window?.windowScene {
            if #available(iOS 14.0, *) {
                SKStoreReviewController.requestReview(in: scene)
            } else {
                SKStoreReviewController.requestReview()
            }
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
