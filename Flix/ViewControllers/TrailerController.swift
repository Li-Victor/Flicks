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
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieID!)/videos?api_key=\(APIKeys.MOVIE_DATABASE.rawValue)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)

        let task = session.dataTask(with: request) {
            (data, response, error) in
            
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let movieVideos = JSON(data)
                let key = movieVideos["results", 0, "key"].stringValue
                let youtubeURL = URL(string: "https://www.youtube.com/watch?v=\(key)")!
                let youtubeRequest = URLRequest(url: youtubeURL)
                self.webView.load(youtubeRequest)
            }
        }
        task.resume()
    }

    @objc func goBack(_ navLeftBar: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}
