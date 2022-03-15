//
//  TableViewController + Ext.swift
//  MoviesList
//
//  Created by Aleksandra on 05.03.2022.
//

import UIKit

extension UITableViewController {
    
    func presentAlertController(withTitle title: String?, message: String?, complitionHandler:  @escaping (String) -> Void) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addTextField { tf in
            let movies = ["Parasite",
                          "Titanic",
                          "Casablanca",
                          "A Star Is Born",
                          "Promising Young Woman",
                          "Rocky",
                          "Schindler's List"]
            tf.placeholder = movies.randomElement()
        }
        let add = UIAlertAction(title: "Add", style: .default) { action in
            let textField = ac.textFields?.first
            guard let movieName = textField?.text else { return }
            if movieName != "" {
                let movie = movieName
                complitionHandler(movie)
            }
    }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        ac.addAction(add)
        ac.addAction(cancelAction)
        present(ac, animated: true)
    }
}
