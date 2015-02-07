//
//  Cast.swift
//  RottenTomatoesSwift
//
//  Created by Kristen on 2/6/15.
//  Copyright (c) 2015 Kristen Sundquist. All rights reserved.
//

import Foundation

class Cast: NSObject {
    let name: String
    let characters: [String]
    
    init(dictionary: NSDictionary) {
        self.name = dictionary["name"] as String
        if let characters = dictionary["characters"] as? [String] {
            self.characters = characters
        } else {
            self.characters = []
        }
           
    }
}