//
//  ViewController.swift
//  RottenTomatoesSwift
//
//  Created by Kristen on 2/2/15.
//  Copyright (c) 2015 Kristen Sundquist. All rights reserved.
//

import UIKit

// http://paletton.com/#uid=74U0u0kqljxhvs5mjnAv6eLGe9t

class ViewController: UIViewController, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate {
    
    @IBOutlet weak var moviesTableView: UITableView!
    @IBOutlet weak var networkErrorLabel: UILabel!
    @IBOutlet weak var movieSearchBar: UISearchBar!
    
    var refreshControl: UIRefreshControl!
    var moviesArray = [NSDictionary]()
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
            if error == nil && data != nil {
                if self.networkError {
                    self.hideNetworkError(networkErrorYPosition - networkErrorLabelHeight)
                    self.networkError = false
                }
                var errorValue: NSError? = nil
                var responseDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &errorValue) as NSDictionary
                if errorValue == nil {
                    self.moviesArray = responseDictionary["movies"] as [NSDictionary]
                    self.moviesTableView.reloadData()
                }
                self.refreshControl.endRefreshing()
                MBProgressHUD.hideHUDForView(self.view, animated: true)
            } else {
                self.networkError = true
                self.showNetworkError(networkErrorYPosition - networkErrorLabelHeight, finalPosition: networkErrorYPosition)
            }
        }

    }
    
    func hideNetworkError(yPosition: CGFloat) {
        UIView.animateWithDuration(0.4, delay: 3.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.networkErrorLabel.alpha = 0.0
            self.networkErrorLabel.center.y = yPosition
            }, completion: nil)
    }
    
    func showNetworkError(initialPosition: CGFloat, finalPosition: CGFloat) {
        self.networkErrorLabel.center.y = initialPosition
        UIView.animateWithDuration(0.4, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            self.networkErrorLabel.alpha = 1
            self.networkErrorLabel.center.y = finalPosition
            }, completion: { (finished) -> Void in
                if finished {
                    self.refreshControl.endRefreshing()
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                }
        })
    }
    
    //    #pragma mark - UISearchBarDelegate

    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchText as NSString).length == 0 {
            isFiltered = false
        } else {
            isFiltered = true
            filteredMovies = moviesArray.filter {
                movieDict in
                let movie = Movie(dictionary: movieDict)
                return movie.title.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch) != nil
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
        } else {
            return moviesArray.count
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let movieCell = tableView.dequeueReusableCellWithIdentifier("MyMovieCell") as MovieTableViewCell
        
        var movieDictionary = getMovieDictionary(forIndex: indexPath.row)
        
        let movie = Movie(dictionary: movieDictionary)
        
        movieCell.movieTitleLabel.text = movie.title
        movieCell.synopsisLabel.text = movie.synopsis
        
        setPosterImageFor(movieCell, withMovie: movie)
                
        return movieCell
    }
    
    func setPosterImageFor(movieCell: MovieTableViewCell, withMovie movie: Movie) {
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
    }
    
    func getMovieDictionary(forIndex index: Int) -> NSDictionary {
        if isFiltered {
            return self.filteredMovies[index]
        } else {
            return self.moviesArray[index]
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showDetailView" {
            let mdvc = segue.destinationViewController as MovieDetailViewController
            if let selectedIndexPath = moviesTableView.indexPathForSelectedRow() {
                var movieDictionary = getMovieDictionary(forIndex: selectedIndexPath.row)
                let movie = Movie(dictionary: movieDictionary) as Movie
                mdvc.movie = movie
            }
        }
    }
}

