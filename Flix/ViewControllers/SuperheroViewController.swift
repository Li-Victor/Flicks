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
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private var movies: [Movie] = [] {
        didSet {
            PKHUD.sharedHUD.hide(afterDelay: 0.10)
            collectionView.reloadData()
            refreshControl.endRefreshing()
        }
    }
    private var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        
        // adding refresh control to collection view
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(didPullToRefresh(_:)), for: .valueChanged)
        collectionView.insertSubview(refreshControl, at: 0)
        
        // calculating spacing between each cell
        let layout  = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = layout.minimumInteritemSpacing
        let cellsPerLine: CGFloat = 2
        let interItemSpacingTotal = layout.minimumInteritemSpacing * (cellsPerLine - 1)
        let width = collectionView.frame.size.width / cellsPerLine - interItemSpacingTotal / cellsPerLine
        layout.itemSize = CGSize(width: width, height: width * 3 / 2)
        
        fetchMovies()
    }
    
    @objc private func didPullToRefresh(_ refreshControl: UIRefreshControl) {
        fetchMovies()
    }
    
    private func fetchMovies() {
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show(onView: collectionView)
        let wonderWomanID = 297762
        
        MovieApiManager.shared.similarMovies(movieId: wonderWomanID) { (movies: [Movie]?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
                self.displayError(error)
            } else if let movies = movies {
                self.movies = movies
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PosterCell", for: indexPath) as! PosterCell
        let movie = movies[indexPath.item]
        cell.movie = movie
        
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
