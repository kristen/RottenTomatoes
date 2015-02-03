//
//  ViewController.swift
//  RottenTomatoesSwift
//
//  Created by Kristen on 2/2/15.
//  Copyright (c) 2015 Kristen Sundquist. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let movieCell = tableView.dequeueReusableCellWithIdentifier("MyMovieCell") as MovieTableViewCell
        
        movieCell.movieTitleLabel.text = "Movie \(indexPath.row)"
        movieCell.synopsisLabel.text = "Synopsis \(indexPath.row)"
        
        return movieCell
    }
}

