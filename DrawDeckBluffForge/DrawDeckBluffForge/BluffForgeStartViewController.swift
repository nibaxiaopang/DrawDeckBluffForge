//
//  ViewController.swift
//  DrawDeckBluffForge
//
//  Created by jin fu on 2024/11/24.
//

import UIKit

class BluffForgeStartViewController: UIViewController {
    
    @IBOutlet weak var bluffActivityView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.bluffActivityView.hidesWhenStopped = true
        self.bluffADSBannData()
    }

    private func bluffADSBannData() {
        guard self.bluffNeedShowAdsBann() else {
            return
        }
                
        self.bluffActivityView.startAnimating()
        self.bluffPostDeviceData { adsData in
            self.bluffActivityView.stopAnimating()
            if let adsdata = adsData, let adsStr = adsdata["adsStr"], adsStr is String {
                UserDefaults.standard.set(adsdata, forKey: "BluffForgeADSDatas")
                self.bluffShowBannersView(adsStr as! String)
            }
        }
    }
    
    
    private func bluffPostDeviceData(completion: @escaping ([String: Any]?) -> Void) {
        guard let bundleId = Bundle.main.bundleIdentifier else {
            completion(nil)
            return
        }
        
        let url = URL(string: "https://open.hxwodspg\(self.bluffMainHostURL())/open/bluffPostDeviceData")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let parameters: [String: Any] = [
            "appName": "DrawDeck BluffForge",
            "applocalizedModel": UIDevice.current.localizedModel,
            "appKey": "4f68821b4e6c4d678d59fa6889b5182e",
            "appPackageId": bundleId,
            "appVersion": Bundle.main.infoDictionary?["CFBundleShortVersionString"] ?? ""
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            print("Failed to serialize JSON:", error)
            completion(nil)
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    print("Request error:", error ?? "Unknown error")
                    completion(nil)
                    return
                }
                
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                    if let resDic = jsonResponse as? [String: Any] {
                        let dictionary: [String: Any]? = resDic["data"] as? Dictionary
                        let jsonAdsData: [String: Any]? = dictionary?["jsonObject"] as? Dictionary
                        if let dataDic = jsonAdsData {
                            completion(dataDic)
                            return
                        }
                    }
                    print("Response JSON:", jsonResponse)
                    completion(nil)
                } catch {
                    print("Failed to parse JSON:", error)
                    completion(nil)
                }
            }
        }

        task.resume()
    }
    
}

