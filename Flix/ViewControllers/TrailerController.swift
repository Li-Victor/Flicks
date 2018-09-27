//
//  TrailerController.swift
//  Flix
//
//  Created by Victor Li on 9/5/18.
//  Copyright © 2018 Victor Li. All rights reserved.
//

import UIKit
import WebKit
import SwiftyJSON

class TrailerController: UIViewController, WKUIDelegate {
    
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet private weak var webView: WKWebView!
    
    var movieID: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navItem.leftBarButtonItem =  UIBarButtonItem(title: "Back", style: .plain, target: nil, action: #selector(TrailerController.goBack(_:)))
        
        MovieApiManager.shared.fetchTrailer(movieId: movieID!) { (request: URLRequest?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else if let request = request {
                self.webView.load(request)
            }
        }
    }

    @objc func goBack(_ navLeftBar: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}
