//
//  TrailerController.swift
//  Flix
//
//  Created by Victor Li on 9/5/18.
//  Copyright © 2018 Victor Li. All rights reserved.
//

import UIKit
import WebKit

class TrailerController: UIViewController, WKUIDelegate {
    
    @IBOutlet weak var webView: WKWebView!
    
    var youtubeKey: String!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("https://www.youtube.com/watch?v=\(youtubeKey)")
        let youtubeURL = URL(string: "https://www.youtube.com/watch?v=MFWF9dU5Zc0")!
        let youtubeRequest = URLRequest(url: youtubeURL)
        webView.load(youtubeRequest)
    }

}
