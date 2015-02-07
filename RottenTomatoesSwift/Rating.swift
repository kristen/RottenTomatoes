//
//  Rating.swift
//  RottenTomatoesSwift
//
//  Created by Kristen on 2/6/15.
//  Copyright (c) 2015 Kristen Sundquist. All rights reserved.
//

import Foundation

class Rating: NSObject {
    let critics_rating: String
    let critics_score: Int
    let audience_rating: String
    let audience_score: Int
    
    init(dictionary: NSDictionary) {
        self.critics_rating = dictionary["critics_rating"]! as String
        self.critics_score = dictionary["critics_score"]! as Int
        self.audience_rating = dictionary["audience_rating"]! as String
        self.audience_score = dictionary["audience_score"]! as Int
    }
}
