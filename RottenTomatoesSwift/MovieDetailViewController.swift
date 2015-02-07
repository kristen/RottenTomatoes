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
    @IBOutlet weak var synopsisLabel: UILabel!
    @IBOutlet weak var castLabel: UILabel!
    @IBOutlet weak var criticsScoreLabel: UILabel!
    @IBOutlet weak var audienceScoreLabel: UILabel!
    
    var movie: Movie!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadData()
    }
    
    func reloadData() {
        navigationItem.title = movie.title
        
        synopsisLabel.text = movie.synopsis
        
        criticsScoreLabel.text = "Critics Score: \(movie.rating.critics_score)"
        audienceScoreLabel.text = "Audience Score: \(movie.rating.audience_score)"
        
        let castList = movie.cast.map { $0.name }
        let castString = NSArray(array: castList).componentsJoinedByString(", ")
        castLabel.text = "Cast: \(castString)"

        let url = NSURL(string: movie.imageURL)
        posterImageView.setImageWithURL(url)

    }
}
