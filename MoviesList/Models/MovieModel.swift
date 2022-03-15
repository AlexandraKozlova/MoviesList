//
//  MovieModel.swift
//  MoviesList
//
//  Created by Aleksandra on 11.01.2022.
//

import UIKit
import RealmSwift

class Movie: Object {

    @objc dynamic var name = ""
    @objc dynamic var imageData: Data?
    @objc dynamic var releaseYear: String?
    @objc dynamic var rating = 0.0

    convenience init(name: String, imageData: Data?, releaseYear: String?, rating: Double) {
        self.init()
        self.name = name
        self.imageData = imageData
        self.releaseYear = releaseYear
        self.rating = rating
        }
   }


    

