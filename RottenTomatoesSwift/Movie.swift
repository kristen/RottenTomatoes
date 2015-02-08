//
//  Movie.swift
//  RottenTomatoesSwift
//
//  Created by Kristen on 2/3/15.
//  Copyright (c) 2015 Kristen Sundquist. All rights reserved.
//

import Foundation

class Movie: NSObject {
    let title: String
    let synopsis: String
    let cast: [Cast]
    let rating: Rating
    let loResImageURL: String
    let hiResImageURL: String
    let mpaa_rating: String

    init(dictionary: NSDictionary) {
        self.title = dictionary["title"] as String
        self.synopsis = dictionary["synopsis"] as String
        self.cast = []
        let abridged_cast = dictionary["abridged_cast"] as [NSDictionary]
        for cast in abridged_cast {
            self.cast.append(Cast(dictionary: cast))
        }
        
        let ratings = dictionary["ratings"] as NSDictionary
        self.rating = Rating(dictionary: ratings)
        
        let posters = dictionary["posters"] as NSDictionary
        
        self.loResImageURL = posters["detailed"] as String
        self.hiResImageURL = loResImageURL.stringByReplacingOccurrencesOfString("_tmb.jpg", withString: "_ori.jpg", options: NSStringCompareOptions.LiteralSearch, range: nil)
        self.mpaa_rating = dictionary["mpaa_rating"] as String
    }
}