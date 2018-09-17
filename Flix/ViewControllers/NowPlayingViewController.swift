//
//  NowPlayingViewController.swift
//  Flicks
//
//  Created by Victor Li on 8/23/18.
//  Copyright © 2018 Victor Li. All rights reserved.
//

import UIKit
import AlamofireImage
import PKHUD
import SwiftyJSON

class NowPlayingViewController: UIViewController, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet private weak var tableView: UITableView!
    
    @IBOutlet weak var navItem: UINavigationItem!
    
    var searchBar: UISearchBar!
    private var movies: [Movie] = []
    private var filteredMovies: [Movie] = []
    private var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
        
        searchBar = UISearchBar()
        searchBar.sizeToFit()
        searchBar.placeholder = "Filter By Name"
        navItem.titleView = searchBar
        searchBar.delegate = self
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(NowPlayingViewController.didPullToRefresh(_:)), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        self.tableView.dataSource = self
        
        fetchMovies()
    }
    
    @objc private func didPullToRefresh(_ refreshControl: UIRefreshControl) {
        fetchMovies()
    }
    
    private func fetchMovies() {
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show(onView: tableView)
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(APIKeys.MOVIE_DATABASE.rawValue)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) {
            (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
                self.displayError(error)
            } else if let data = data {
                
                let allMovieInfo = JSON(data)
                
                PKHUD.sharedHUD.hide(afterDelay: 0.10)
                self.movies = allMovieInfo["results"].arrayValue.map {
                    let title = $0["title"].stringValue
                    let overview = $0["overview"].stringValue
                    let releaseDate = $0["release_date"].stringValue
                    let posterImagePath = $0["poster_path"].stringValue
                    let backdropImagePath = $0["backdrop_path"].stringValue
                    let movieId = $0["id"].intValue
                    return Movie(title: title, overview: overview, releaseDate: releaseDate, posterImagePath: posterImagePath, backdropImagePath: backdropImagePath, movieId: movieId)
                }
                
                self.filteredMovies = self.movies
                
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
        task.resume()
    }
    
    private func displayError(_ error: Error) {
        let alertController = UIAlertController(title: "Cannot Get Movies", message: error.localizedDescription, preferredStyle: .alert)
        
        let TryAgainAction = UIAlertAction(title: "Try Again", style: .default) { (action) in
            self.fetchMovies()
        }
        
        alertController.addAction(TryAgainAction)
        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        let movie = filteredMovies[indexPath.row]
        let title = movie.title
        let overview = movie.overview
        let posterPath = movie.posterImagePath
        
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        
        let lowResURLString = "https://image.tmdb.org/t/p/w45"
        let lowResPosterURL = URL(string: lowResURLString + posterPath)!
        
        let highResURLString = "https://image.tmdb.org/t/p/original"
        let highResPosterURL = URL(string: highResURLString + posterPath)!
        
        let placeholderImage = UIImage(named: "iconmonstr-video")!
        
        let filter = AspectScaledToFillSizeWithRoundedCornersFilter(
            size: cell.posterImageView.frame.size,
            radius: 0.0
        )
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.black
        cell.selectedBackgroundView = backgroundView
        
        cell.posterImageView.af_setImage(withURL: lowResPosterURL, placeholderImage: placeholderImage, filter: filter, imageTransition: .crossDissolve(0.2),
                                         completion: { (response) in
                                            cell.posterImageView.af_setImage(withURL: highResPosterURL, filter: filter, imageTransition: .crossDissolve(0.2))
        })
        
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        self.filteredMovies = searchText.isEmpty ? self.movies : self.movies.filter {
            let title = $0.title
            return title.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        self.tableView.reloadData()
        if self.filteredMovies.count > 0 {
            tableView.scrollToRow(at: IndexPath(indexes: [0, 0]), at: .bottom, animated: true)
        }
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = false
        self.searchBar.text = ""
        self.searchBar.resignFirstResponder()
        self.filteredMovies = self.movies
        self.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        if let indexPath = tableView.indexPath(for: cell) {
            let movie = filteredMovies[indexPath.row]
            let detailViewController = segue.destination as! DetailViewController
            detailViewController.movie = movie
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
