//
//  Movie.swift
//  Flix
//
//  Created by Victor Li on 9/4/18.
//  Copyright © 2018 Victor Li. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Movie {
    let title: String
    let overview: String
    let releaseDate: String
    let movieId: Int
    let lowResPosterURL: URL
    let highResPosterURL: URL
    let backdropImageURL: URL
    
    private static func parseToMovie(json movieJSON: JSON) -> Movie {
        let title = movieJSON["title"].stringValue
        let overview = movieJSON["overview"].stringValue
        let releaseDate = movieJSON["release_date"].stringValue
        let posterImagePath = movieJSON["poster_path"].stringValue
        let backdropImagePath = movieJSON["backdrop_path"].stringValue
        let movieId = movieJSON["id"].intValue
        
        let lowResURLString = "https://image.tmdb.org/t/p/w45"
        let lowResPosterURL = URL(string: lowResURLString + posterImagePath)!
        
        let highResURLString = "https://image.tmdb.org/t/p/original"
        let highResPosterURL = URL(string: highResURLString + posterImagePath)!
        
        let baseURLString = "https://image.tmdb.org/t/p/w500"
        let backDropImageURL = URL(string: baseURLString + backdropImagePath)!
        
        return Movie(title: title, overview: overview, releaseDate: releaseDate, movieId: movieId, lowResPosterURL: lowResPosterURL, highResPosterURL: highResPosterURL, backdropImageURL: backDropImageURL)
    }
    
    static func getMovies(_ json: [JSON]) -> [Movie] {
        return json.map { Movie.parseToMovie(json: $0) }
    }
}
