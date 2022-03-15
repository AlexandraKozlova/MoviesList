//
//  WillWatchViewController.swift
//  MoviesList
//
//  Created by Aleksandra on 07.03.2022.
//

import UIKit
import RealmSwift

class WillWatchViewController: UITableViewController {
    
    var willWatchMovie: Results<WillWatch>!
    let image = UIImage(named: "standart")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        willWatchMovie = realm.objects(WillWatch.self)
   }
    
    @IBAction func addMovie(_ sender: UIBarButtonItem) {
        presentAlertController(withTitle: "Enter name of movie", message: "What movie would you like to see?") { nameOfMovie in
            let movie = WillWatch()
            movie.name = nameOfMovie
            StorageManager.saveObject(movie)
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if willWatchMovie.count != 0 { return willWatchMovie.count }
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WillWatch", for: indexPath) as! WillWatchCell
        let movie = willWatchMovie[indexPath.row]
        cell.movieName.text = movie.name
        cell.movieImage.image = image
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let movie = willWatchMovie[indexPath.row]
            StorageManager.deleteObject(movie)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AlreadyWatch" {
            print("segue")
           guard let indexPath = tableView.indexPathForSelectedRow else { return }
           let imageData = image?.pngData()

            let movie = willWatchMovie[indexPath.row]
            let currentMovie = Movie(name: movie.name, imageData: imageData, releaseYear: nil, rating: 0.0)
            let detailMovieVC = segue.destination as? NewMovieViewController
            detailMovieVC?.willWatchMovie = currentMovie
        }
    }
}
