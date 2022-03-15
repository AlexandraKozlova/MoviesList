//
//  ListController.swift
//  MoviesList
//
//  Created by Aleksandra on 21.12.2021.
//

import UIKit
import RealmSwift
import Cosmos

class ListController: UITableViewController {
    
    private var movies: Results<Movie>!
    private var filteredMovies: Results<Movie>!
    private var aspendingSorting = true
    private let searchController = UISearchController(searchResultsController: nil)

    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
     var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }

    @IBOutlet weak var reversedSortingButton: UIBarButtonItem!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movies = realm.objects(Movie.self)
        configureSearchController()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering { return filteredMovies.count }
        return  movies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as! MovieCell
        let movie = isFiltering ? filteredMovies[indexPath.row] : movies[indexPath.row]

        cell.nameLabel.text = movie.name
        cell.yearLabel.text = movie.releaseYear
        cell.imageMovie.image  = UIImage(data: movie.imageData!)
        cell.starRating.rating = movie.rating

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let movie = movies[indexPath.row]
            StorageManager.deleteObject(movie)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
        }
    }
    
    private func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search movie"
        searchController.definesPresentationContext = true
        navigationItem.searchController = searchController
    }

    @IBAction func reversedSortingButtonTapped(_ sender: UIBarButtonItem) {
        aspendingSorting.toggle()
        
        if aspendingSorting {
            reversedSortingButton.image = #imageLiteral(resourceName: "AZ")
        } else {
            reversedSortingButton.image = #imageLiteral(resourceName: "ZA")
        }
        sorting()
    }
    
    @IBAction func sortSelection(_ sender: UISegmentedControl) {
    sorting()
    }
    
    private func sorting() {
        if segmentedControl.selectedSegmentIndex == 0 {
            movies = movies.sorted(byKeyPath: "releaseYear", ascending: aspendingSorting)
        } else {
            movies = movies.sorted(byKeyPath: "name", ascending: aspendingSorting)
        }
        tableView.reloadData()
    }
    
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        guard let newMovieVC = segue.source as? NewMovieViewController else { return }
        newMovieVC.saveMovie()
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
           guard let indexPath = tableView.indexPathForSelectedRow else { return }
            
            let movie = isFiltering ? filteredMovies[indexPath.row] : movies[indexPath.row]
            let detailMovieVC = segue.destination as? NewMovieViewController
            detailMovieVC?.currentMovie = movie
        }
    }
}


extension ListController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filteredContentFor(searchController.searchBar.text!)
    }
    
    private func filteredContentFor(_ searchText: String) {
        filteredMovies = movies.filter("name CONTAINS[c] %@", searchText, searchText)
        tableView.reloadData()
    }
    
}
