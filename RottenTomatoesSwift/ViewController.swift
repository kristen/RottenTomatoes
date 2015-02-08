//
//  ViewController.swift
//  RottenTomatoesSwift
//
//  Created by Kristen on 2/2/15.
//  Copyright (c) 2015 Kristen Sundquist. All rights reserved.
//

import UIKit

// http://paletton.com/#uid=74U0u0kqljxhvs5mjnAv6eLGe9t

class ViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var moviesTableView: UITableView!
    @IBOutlet weak var networkErrorLabel: UILabel!
    var refreshControl: UIRefreshControl!
    var moviesArray: NSArray!
    var networkError: Bool = false
    var rottenTomatoesURL: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        moviesTableView.rowHeight = 96
        
//        navigationController?.navigationBar.barTintColor = UIColor(red: 46/255.0, green: 0/255.0, blue: 49/255.0, alpha: 1.0)
//        navigationController?.navigationBar.tintColor = UIColor(red: 199/255.0, green: 217/255.0, blue: 98/255.0, alpha: 1.0)

//        navigationController?.navigationBar.translucent = false
//        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor(red: 199/255.0, green: 217/255.0, blue: 98/255.0, alpha: 1.0)

        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "fetchMovies", forControlEvents: UIControlEvents.ValueChanged)
        moviesTableView.insertSubview(refreshControl, atIndex: 0)
        fetchMovies()
    }
    
    func fetchMovies() {
        MBProgressHUD.showHUDAddedTo(view, animated: true)
        var networkErrorLabelHeight = networkErrorLabel.frame.height
        var networkErrorYPosition = networkErrorLabel.center.y
        networkErrorLabel.alpha = 0.0
        
        let request = NSMutableURLRequest(URL: NSURL(string: rottenTomatoesURL)!)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
            if error == nil {
                if self.networkError {
                    UIView.animateWithDuration(0.4, delay: 3.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                        self.networkErrorLabel.alpha = 0.0
                        self.networkErrorLabel.center.y = networkErrorYPosition - networkErrorLabelHeight
                        }, completion: nil)
                    self.networkError = false
                }
                var errorValue: NSError? = nil // very bad person for not checking errorValue
                var responseDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &errorValue) as NSDictionary
                self.moviesArray = responseDictionary["movies"] as? NSArray
                self.moviesTableView.reloadData()
                self.refreshControl.endRefreshing()
                MBProgressHUD.hideHUDForView(self.view, animated: true)
            } else {
                self.networkError = true
                self.networkErrorLabel.center.y = networkErrorYPosition - networkErrorLabelHeight
                UIView.animateWithDuration(0.4, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                    self.networkErrorLabel.alpha = 1
                    self.networkErrorLabel.center.y = networkErrorYPosition
                    }, completion: { (finished) -> Void in
                        if finished {
                            self.refreshControl.endRefreshing()
                            MBProgressHUD.hideHUDForView(self.view, animated: true)
                        }
                })
            }
        }

    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let array = moviesArray {
            return array.count
        } else {
            return 0
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
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
            if let selectedIndexPath = moviesTableView.indexPathForSelectedRow() {
                let movieDictionary = moviesArray![selectedIndexPath.row] as NSDictionary
                let movie = Movie(dictionary: movieDictionary) as Movie
                mdvc.movie = movie
            }
        }
    }
}

