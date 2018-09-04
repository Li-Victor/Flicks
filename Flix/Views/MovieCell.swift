//
//  MovieCell.swift
//  Flicks
//
//  Created by Victor Li on 8/24/18.
//  Copyright © 2018 Victor Li. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    
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
