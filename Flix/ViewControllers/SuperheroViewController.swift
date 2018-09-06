//
//  SuperheroViewController.swift
//  Flix
//
//  Created by Victor Li on 9/4/18.
//  Copyright © 2018 Victor Li. All rights reserved.
//

import UIKit
import AlamofireImage
import PKHUD

class SuperheroViewController: UIViewController, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var movies: [Movie] = []
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(NowPlayingViewController.didPullToRefresh(_:)), for: .valueChanged)
        collectionView.insertSubview(refreshControl, at: 0)
        
        let layout  = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = layout.minimumInteritemSpacing
        let cellsPerLine: CGFloat = 2
        let interItemSpacingTotal = layout.minimumInteritemSpacing * (cellsPerLine - 1)
        let width = collectionView.frame.size.width / cellsPerLine - interItemSpacingTotal / cellsPerLine
        layout.itemSize = CGSize(width: width, height: width * 3 / 2)
        
        fetchMovies()
    }
    
    @objc func didPullToRefresh(_ refreshControl: UIRefreshControl) {
        fetchMovies()
    }
    
    func fetchMovies() {
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show(onView: collectionView)
        let wonderWomanID = 297762
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(wonderWomanID)/similar?api_key=\(APIKeys.MOVIE_DATABASE.rawValue)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) {
            (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
                self.displayError(error)
            } else if let data = data {
                PKHUD.sharedHUD.hide(afterDelay: 0.10)
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                let movieResults = dataDictionary["results"] as! [[String: Any]]
                
                self.movies = movieResults.map {
                    let title = $0["title"] as! String
                    let overview = $0["overview"] as! String
                    let releaseDate = $0["release_date"] as! String
                    let posterImagePath = $0["poster_path"] as! String
                    let backdropImagePath = $0["backdrop_path"] as! String
                    return Movie(title: title, overview: overview, releaseDate: releaseDate, posterImagePath: posterImagePath, backdropImagePath: backdropImagePath)
                }
                
                self.collectionView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
        task.resume()
    }
    
    func displayError(_ error: Error) {
        let alertController = UIAlertController(title: "Cannot Get Movies", message: error.localizedDescription, preferredStyle: .alert)
        
        let TryAgainAction = UIAlertAction(title: "Try Again", style: .default) { (action) in
            self.fetchMovies()
        }
        
        alertController.addAction(TryAgainAction)
        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PosterCell", for: indexPath) as! PosterCell
        let movie = movies[indexPath.item]
        let posterPathString = movie.posterImagePath
        
        let lowResURLString = "https://image.tmdb.org/t/p/w45"
        let lowResPosterURL = URL(string: lowResURLString + posterPathString)!
        
        let highResURLString = "https://image.tmdb.org/t/p/original"
        let highResPosterURL = URL(string: highResURLString + posterPathString)!
        
        let placeholderImage = UIImage(named: "iconmonstr-video")!
        
        let filter = AspectScaledToFillSizeWithRoundedCornersFilter(
            size: cell.posterImageView.frame.size,
            radius: 0.0
        )
        
        cell.posterImageView.af_setImage(withURL: lowResPosterURL, placeholderImage: placeholderImage, filter: filter, imageTransition: .crossDissolve(0.2), completion: {(response) in
            
            cell.posterImageView.af_setImage(withURL: highResPosterURL, filter: filter, imageTransition: .crossDissolve(0.2))
        })
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UICollectionViewCell
        if let indexPath = collectionView.indexPath(for: cell) {
            let movie = movies[indexPath.row]
            let detailViewController = segue.destination as! DetailViewController
            detailViewController.movie = movie
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
