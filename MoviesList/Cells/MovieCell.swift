//
//  MovieCell.swift
//  MoviesList
//
//  Created by Aleksandra on 21.12.2021.
//

import UIKit
import Cosmos

class MovieCell: UITableViewCell {

   @IBOutlet weak var imageMovie: UIImageView!
   @IBOutlet weak var nameLabel: UILabel!
   @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var starRating: CosmosView! {
        didSet {
            starRating.settings.updateOnTouch = false
        }
    }
}
