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
    let imageURL: String

    init(dictionary: NSDictionary) {
        self.title = dictionary["title"] as String
        self.synopsis = dictionary["synopsis"] as String
        
        
        let posters = dictionary["posters"] as NSDictionary
        self.imageURL = posters["thumbnail"] as String
    }
}