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

class NowPlayingViewController: UIViewController, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet private weak var tableView: UITableView!
    
    @IBOutlet weak var navItem: UINavigationItem!
    
    private var searchBar: UISearchBar!
    private var movies: [Movie] = []
    private var filteredMovies: [Movie] = [] {
        didSet {
            PKHUD.sharedHUD.hide(afterDelay: 0.10)
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    private var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
        
        // add refresh control on top of tableView
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(NowPlayingViewController.didPullToRefresh(_:)), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        searchBar = UISearchBar()
        searchBar.sizeToFit()
        searchBar.placeholder = "Filter By Name"
        searchBar.delegate = self
        navItem.titleView = searchBar
        
        fetchMovies()
    }
    
    @objc private func didPullToRefresh(_ refreshControl: UIRefreshControl) {
        fetchMovies()
    }
    
    private func fetchMovies() {
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show(onView: tableView)
        
        MovieApiManager.shared.nowPlayingMovies { (movies: [Movie]?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
                self.displayError(error)
            } else if let movies = movies {
                self.movies = movies
                self.filteredMovies = self.movies
            }
        }
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

        cell.movie = filteredMovies[indexPath.row]
        
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredMovies = searchText.isEmpty ? self.movies : self.movies.filter {
            let title = $0.title
            return title.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        
        // move tableView to the top of the movie list
        if filteredMovies.count > 0 {
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
