//
//  TrailerController.swift
//  Flix
//
//  Created by Victor Li on 9/5/18.
//  Copyright © 2018 Victor Li. All rights reserved.
//

import UIKit

class TrailerController: UIViewController {
    
    @IBOutlet weak var dataLabel: UILabel!
    
    var youtubeURL: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        dataLabel.text = youtubeURL
        // Do any additional setup after loading the view.
    }

}
