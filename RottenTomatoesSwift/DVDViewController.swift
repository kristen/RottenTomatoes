//
//  DVDViewController.swift
//  RottenTomatoesSwift
//
//  Created by Kristen on 2/7/15.
//  Copyright (c) 2015 Kristen Sundquist. All rights reserved.
//

import UIKit

class DVDViewController: ViewController {
    
    override func viewDidLoad() {
        self.rottenTomatoesURL = "http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=ws32mxpd653h5c8zqfvksxw9&limit=50&country=us"
        super.viewDidLoad()
    }
}
