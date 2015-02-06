//
//  ViewController.swift
//  RottenTomatoesSwift
//
//  Created by Kristen on 2/2/15.
//  Copyright (c) 2015 Kristen Sundquist. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var moviesArray: NSArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let RottenTomatoesURLString = "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=ws32mxpd653h5c8zqfvksxw9&limit=20&country=us"
        let request = NSMutableURLRequest(URL: NSURL(string: RottenTomatoesURLString)!)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
//            var errorValue: NSError? = nil // very bad person for not checking errorValue
//            let dictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &errorValue) as NSDictionary
            var responseDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
            self.moviesArray = responseDictionary["movies"] as NSArray
            self.tableView.reloadData()
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let array = moviesArray {
            return array.count
        } else {
            return 0
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let movieCell = tableView.dequeueReusableCellWithIdentifier("MyMovieCell") as MovieTableViewCell
        let movieDictionary = self.moviesArray![indexPath.row] as NSDictionary
        let movie = Movie(dictionary: movieDictionary)
        
        movieCell.movieTitleLabel.text = movie.title
        movieCell.synopsisLabel.text = movie.synopsis
        let url = NSURL(string: movie.imageURL)
        movieCell.posterImageView.setImageWithURL(url)
        
        return movieCell
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showDetailView" {
            let mdvc = segue.destinationViewController as MovieDetailViewController
            if let selectedIndexPath = tableView.indexPathForSelectedRow() {
                let movieDictionary = moviesArray![selectedIndexPath.row] as NSDictionary
                let movie = Movie(dictionary: movieDictionary) as Movie
                mdvc.movie = movie
            }
        }
    }
}

