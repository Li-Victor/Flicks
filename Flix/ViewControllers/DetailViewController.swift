//
//  DetailViewController.swift
//  Flix
//
//  Created by Victor Li on 9/3/18.
//  Copyright © 2018 Victor Li. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet private weak var backDropImageView: UIImageView!
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var releaseDateLabel: UILabel!
    @IBOutlet private weak var overviewLabel: UILabel!
    
    @IBAction private func didTapBackDropImage(_ sender: UITapGestureRecognizer) {
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
        
        let trailerController = segue.destination as! TrailerController
        trailerController.movieID = movie!.movieId
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
