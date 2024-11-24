//
//  BluffForgePolicyViewController.swift
//  DrawDeckBluffForge
//
//  Created by jin fu on 2024/11/24.
//

import UIKit
import WebKit

class BluffForgePolicyViewController: UIViewController , WKNavigationDelegate, WKUIDelegate{
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var bgView: UIImageView!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    @IBOutlet weak var tCons: NSLayoutConstraint!
    @IBOutlet weak var bCons: NSLayoutConstraint!
    
    let dic: [String: Any]? = UserDefaults.standard.object(forKey: "BluffForgeADSDatas") as? [String: Any]
    
    let privacyUrl = "https://www.termsfeed.com/live/6619a7ae-7523-404c-8ec3-5a6a3346358e"
    
    @objc var url: String?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        bluffConfigSubViews()
        bluffInitRequest()
    }
    
    @IBAction func back(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let data = dic, let top = data["top"] as? Int, let bot = data["bot"] as? Int {
            if top > 0 {
                tCons.constant = view.safeAreaInsets.top
            }
            
            if bot > 0 {
                bCons.constant = view.safeAreaInsets.bottom
            }
        }
    }
    
    private func bluffConfigSubViews() {
        self.activityView.hidesWhenStopped = true
        self.webView.alpha = 0
        self.webView.navigationDelegate = self
        self.webView.uiDelegate = self
        self.webView.backgroundColor = .black
        self.webView.scrollView.backgroundColor = .black
        self.webView.scrollView.contentInsetAdjustmentBehavior = .never
        self.view.backgroundColor = .black
    }

    private func bluffInitRequest() {
        if let urlStr = url, !urlStr.isEmpty {
            self.backBtn.isHidden = true
            if let urlR = URL(string: urlStr) {
                self.activityView.startAnimating()
                let request = URLRequest(url: urlR)
                webView.load(request)
            }
        } else {
            self.activityView.startAnimating()
            if let urlR = URL(string: privacyUrl) {
                let request = URLRequest(url: urlR)
                webView.load(request)
            }
        }
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.async {
            self.activityView.stopAnimating()
            self.webView.alpha = 1
            self.bgView.isHidden = true
        }
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: any Error) {
        DispatchQueue.main.async {
            self.activityView.stopAnimating()
            self.webView.alpha = 1
            self.bgView.isHidden = true
        }
    }
    
    // MARK: - WKUIDelegate
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            if let url = navigationAction.request.url {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        return nil
    }
}
