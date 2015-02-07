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
        if let crititcs_rating = dictionary["critics_rating"] as? String {
            self.critics_rating = crititcs_rating
        } else {
            self.critics_rating = ""
        }
        if let critics_score = dictionary["critics_score"] as? Int {
            self.critics_score = critics_score
        } else {
            self.critics_score = 0
        }
        if let audience_rating = dictionary["audience_rating"] as? String {
            self.audience_rating = audience_rating
        } else {
            self.audience_rating = ""
        }
        if let audience_score = dictionary["audience_score"] as? Int {
            self.audience_score = audience_score
        } else {
            self.audience_score = 0
        }
    }
}
