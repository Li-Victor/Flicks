//
//  DetailViewController.swift
//  Flix
//
//  Created by Victor Li on 9/3/18.
//  Copyright © 2018 Victor Li. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var backDropImageView: UIImageView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    @IBAction func didTapBackDropImage(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "SegueToVideo", sender: nil)
    }
    
    var movie: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let movie = movie {
            titleLabel.text = movie.title
            releaseDateLabel.text = movie.releaseDate
            overviewLabel.text = movie.overview
            let backdropPathString = movie.backdropImagePath
            
            let posterPathString = movie.posterImagePath
            
            let baseURLString = "https://image.tmdb.org/t/p/w500"
            
            let backdropURL = URL(string: baseURLString + backdropPathString)!
            backDropImageView.af_setImage(withURL: backdropURL)
            
            let posterPathURL = URL(string: baseURLString + posterPathString)!
            posterImageView.af_setImage(withURL: posterPathURL)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        print("hi")
        if let id = movie?.movieId {
            print("sss")
            let url = URL(string: "https://api.themoviedb.org/3/movie/\(id)/videos?api_key=\(APIKeys.MOVIE_DATABASE.rawValue)")!
            let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
            let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
            
            let task = session.dataTask(with: request) {
                (data, response, error) in
                
                if let data = data {
                    let dictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                    
                    let results = dictionary["results"] as! [[String: Any]]
                    
                    let key = results[0]["key"] as! String
                    print(key)
                    let trailerController = segue.destination as! TrailerController
                    trailerController.youtubeKey = "MFWF9dU5Zc0"
                }
            }
            task.resume()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
