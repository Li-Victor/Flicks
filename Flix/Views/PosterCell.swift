//
//  PosterCell.swift
//  Flix
//
//  Created by Victor Li on 9/4/18.
//  Copyright © 2018 Victor Li. All rights reserved.
//

import UIKit
import AlamofireImage

class PosterCell: UICollectionViewCell {
    
    @IBOutlet weak var posterImageView: UIImageView!
    
    var movie: Movie! {
        didSet {
            let placeholderImage = UIImage(named: "iconmonstr-video")!
            
            let filter = AspectScaledToFillSizeWithRoundedCornersFilter(
                size: posterImageView.frame.size,
                radius: 0.0
            )
            
            posterImageView.af_setImage(withURL: movie.lowResPosterURL, placeholderImage: placeholderImage, filter: filter, imageTransition: .crossDissolve(0.2), completion: {(response) in
                
                self.posterImageView.af_setImage(withURL: self.movie.highResPosterURL, filter: filter, imageTransition: .crossDissolve(0.2))
            })
        }
    }
}
