//
//  ViewController.swift
//  RottenTomatoesSwift
//
//  Created by Kristen on 2/2/15.
//  Copyright (c) 2015 Kristen Sundquist. All rights reserved.
//

import UIKit

// http://paletton.com/#uid=74U0u0kqljxhvs5mjnAv6eLGe9t

class ViewController: UIViewController, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate//, UITableViewDelegate
{

    
    @IBOutlet weak var moviesTableView: UITableView!
    @IBOutlet weak var networkErrorLabel: UILabel!
    @IBOutlet weak var movieSearchBar: UISearchBar!
    
    var refreshControl: UIRefreshControl!
    var moviesArray: [NSDictionary]!
    var filteredMovies = [NSDictionary]()
    var networkError: Bool = false
    var rottenTomatoesURL: String!
    var isFiltered: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        moviesTableView.rowHeight = 96
        movieSearchBar.delegate = self
        movieSearchBar.placeholder = "Search"
        movieSearchBar.showsCancelButton = true
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "fetchMovies", forControlEvents: UIControlEvents.ValueChanged)
        moviesTableView.insertSubview(refreshControl, atIndex: 0)
        view.sendSubviewToBack(moviesTableView)
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
                self.moviesArray = responseDictionary["movies"] as? [NSDictionary]
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
    
    //    #pragma mark - UISearchBarDelegate

    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchText as NSString).length == 0 {
            isFiltered = false
        } else {
            isFiltered = true
            self.filteredMovies = self.moviesArray.filter {( movieDict: NSDictionary) -> Bool in
                let movie = Movie(dictionary: movieDict)
                let stringMatch = movie.title.rangeOfString(searchText)
                return stringMatch != nil
            }
        }
        
        moviesTableView.reloadData()
    }
    
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        movieSearchBar.resignFirstResponder()
    }
    
    
//    #pragma mark - UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltered {
            return filteredMovies.count
        } else if let array = moviesArray {
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
        
        var movieDictionary: NSDictionary
        if isFiltered {
            movieDictionary = self.filteredMovies[indexPath.row] as NSDictionary
        } else {
            movieDictionary = self.moviesArray![indexPath.row] as NSDictionary
        }
        
        let movie = Movie(dictionary: movieDictionary)
        
        movieCell.movieTitleLabel.text = movie.title
        movieCell.synopsisLabel.text = movie.synopsis
        let url = NSURL(string: movie.loResImageURL)
        
        movieCell.posterImageView.setImageWithURLRequest(NSMutableURLRequest(URL: url!), placeholderImage: nil, success: { (request, response, loResImage) -> Void in
            movieCell.posterImageView.image = loResImage
            if (request != nil && response != nil) {
                movieCell.posterImageView.alpha = 0.0
                UIView.animateWithDuration(1.0, animations: { () -> Void in
                    movieCell.posterImageView.alpha = 1.0
                })
            }
            }, failure: nil)
        
        return movieCell
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showDetailView" {
            let mdvc = segue.destinationViewController as MovieDetailViewController
            if let selectedIndexPath = moviesTableView.indexPathForSelectedRow() {
                var movieDictionary: NSDictionary
                if isFiltered {
                    movieDictionary = self.filteredMovies[selectedIndexPath.row] as NSDictionary
                } else {
                    movieDictionary = self.moviesArray![selectedIndexPath.row] as NSDictionary
                }
                let movie = Movie(dictionary: movieDictionary) as Movie
                mdvc.movie = movie
            }
        }
    }
}

