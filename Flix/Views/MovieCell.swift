//
//  MovieCell.swift
//  Flicks
//
//  Created by Victor Li on 8/24/18.
//  Copyright © 2018 Victor Li. All rights reserved.
//

import UIKit
import AlamofireImage

class MovieCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    
    var movie: Movie! {
        didSet {
            titleLabel.text = movie.title
            overviewLabel.text = movie.overview
            
            let placeholderImage = UIImage(named: "iconmonstr-video")!
            
            let filter = AspectScaledToFillSizeWithRoundedCornersFilter(
                size: posterImageView.frame.size,
                radius: 0.0
            )
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = UIColor.black
            selectedBackgroundView = backgroundView
            
            posterImageView.af_setImage(withURL: movie.lowResPosterURL, placeholderImage: placeholderImage, filter: filter, imageTransition: .crossDissolve(0.2),
                                        completion: { (response) in
                                            self.posterImageView.af_setImage(withURL: self.movie.highResPosterURL, filter: filter, imageTransition: .crossDissolve(0.2))
            })
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        if selected {
            titleLabel.textColor = UIColor.white
            overviewLabel.textColor = UIColor.white
        } else {
            titleLabel.textColor = UIColor.black
            overviewLabel.textColor = UIColor.black
        }
    }
    
}
