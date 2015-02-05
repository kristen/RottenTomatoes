//
//  MovieDetailViewController.swift
//  RottenTomatoesSwift
//
//  Created by Kristen on 2/3/15.
//  Copyright (c) 2015 Kristen Sundquist. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {

    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var castLabel: UILabel!
    
    var movie: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movieTitleLabel.text = movie?.title
        synopsisLabel.text = movie?.synopsis
        castLabel.text = "blah cast"
        
        if let imageURL = movie?.imageURL {
            let url = NSURL(string: imageURL)
            posterImageView.setImageWithURL(url)
            
        }
    }
}
