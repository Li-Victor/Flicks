//
//  MovieApiManager.swift
//  Flix
//
//  Created by Victor Li on 9/27/18.
//  Copyright © 2018 Victor Li. All rights reserved.
//

import Foundation
import SwiftyJSON

struct MovieApiManager {
    static let baseURL = "https://api.themoviedb.org/3/movie/"
    static let apiKey = APIKeys.MOVIE_DATABASE
    static let shared = MovieApiManager()
    
    let session: URLSession
    
    init() {
        session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
    }
    
    func nowPlayingMovies(completion: @escaping ([Movie]?, Error?) -> ()) {
        let url = URL(string: MovieApiManager.baseURL + "now_playing?api_key=\(MovieApiManager.apiKey)")!
        makeRequest(from: url, completion: completion)
    }
    
    func similarMovies(movieId id: Int, completion: @escaping ([Movie]?, Error?) -> ()) {
        let url = URL(string: MovieApiManager.baseURL + "\(id)/similar?api_key=\(MovieApiManager.apiKey)")!
        makeRequest(from: url, completion: completion)
    }
    
    func fetchTrailer(movieId id: Int, completion: @escaping (URLRequest?, Error?) -> ()) {
        let url = URL(string: MovieApiManager.baseURL + "\(id)/videos?api_key=\(MovieApiManager.apiKey)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(nil, error)
            } else if let data = data {
                let movieVideos = JSON(data)
                let key = movieVideos["results", 0, "key"].stringValue
                let youtubeURL = URL(string: "https://www.youtube.com/watch?v=\(key)")!
                let youtubeRequest = URLRequest(url: youtubeURL)
                completion(youtubeRequest, nil)
            }
        }
        task.resume()
    }
    
    func popularMovies(completion: @escaping ([Movie]?, Error?) -> ()) {
        let url = URL(string: MovieApiManager.baseURL + "popular?api_key=\(MovieApiManager.apiKey)")!
        makeRequest(from: url, completion: completion)
    }
    
    private func makeRequest(from url: URL, completion: @escaping ([Movie]?, Error?) -> ()) {
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            
            if let error = error {
                completion(nil, error)
            } else if let data = data {
                let movies = Movie.getMovies(JSON(data)["results"].arrayValue)
                completion(movies, nil)
            }
        }
        task.resume()
    }
}
