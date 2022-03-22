//
//  NewMovieViewController.swift
//  MoviesList
//
//  Created by Aleksandra on 11.01.2022.
//

import UIKit
import PhotosUI


class NewMovieViewController: UITableViewController {
    
    var currentMovie: Movie!
    var willWatchMovie: Movie!
    var imageIsChange = false
    var movieIsSaved = false

    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var movieName: UITextField!
    @IBOutlet weak var releaseYear: UITextField!
    @IBOutlet weak var ratingControl: RatingControll!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView()
        saveButton.isEnabled = false
        movieName.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        setupEditScreen()
        dismissKeyboard()
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    
    func saveMovie() {
        var image: UIImage?
        
        if imageIsChange {
            image = movieImage.image
        } else {
            image = UIImage(named: "standart")
        }
        let imageData = image?.pngData()
        
        let newMovie = Movie(name: movieName.text!,
                             imageData: imageData,
                             releaseYear: releaseYear.text,
                             rating: Double(ratingControl.rating))
        
        if currentMovie != nil {
            try! realm.write {
                currentMovie?.name = newMovie.name
                currentMovie?.releaseYear = newMovie.releaseYear
                currentMovie?.imageData = newMovie.imageData
                currentMovie?.rating = newMovie.rating
                }
            } else { StorageManager.saveObject(newMovie)
                movieIsSaved = true
            }
        }
    
    func setupEditScreen() {
        configureNavigationBar()
        if currentMovie != nil {
            print("yes")
            guard let data = currentMovie?.imageData, let image = UIImage(data: data) else { return }
            imageIsChange = true
            movieName.text = currentMovie?.name
            movieImage.image = image
            releaseYear.text = currentMovie?.releaseYear
            ratingControl.rating = Int(currentMovie.rating)
        }  else if willWatchMovie != nil {
            guard let data = willWatchMovie?.imageData, let image = UIImage(data: data) else { return }
            movieName.text = willWatchMovie?.name
            movieImage.image = image
            releaseYear.text = willWatchMovie?.releaseYear
            ratingControl.rating = Int(willWatchMovie.rating)
        }
    }
    
    func configureNavigationBar() {
        navigationItem.leftBarButtonItem = nil
        if currentMovie != nil { title = currentMovie?.name }
        else if willWatchMovie != nil { title = willWatchMovie?.name }
        saveButton.isEnabled = true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let photoIcon = UIImage(named: "photo")
        
        if indexPath.row == 0 {
            let actionSheet = UIAlertController(title: nil,
                                                message: nil,
                                                preferredStyle: .actionSheet)
            let photo = UIAlertAction(title: "Galery", style: .default) { _ in
                self.chooseImagePicker(source: .photoLibrary)
            }
            
            photo.setValue(photoIcon, forKey: "image")
            photo.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            
            let delete = UIAlertAction(title: "Delete", style: .default) { _ in
                self.movieImage.image = UIImage(named: "standart")
            }
            let deleteImage = UIImage(systemName: "trash")
            delete.setValue(deleteImage, forKey: "image")
            delete.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")

            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            
            actionSheet.addAction(photo)
            actionSheet.addAction(delete)
            actionSheet.addAction(cancel)
            
            present(actionSheet, animated: true)
        }
    }
    
    private func dismissKeyboard() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
}


extension NewMovieViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc private func textFieldChanged() {
        if movieName.text?.isEmpty == false {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
}


extension NewMovieViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func chooseImagePicker(source: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            present(imagePicker, animated: true)
        }
   }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        movieImage.image = info[.editedImage] as? UIImage
        movieImage.contentMode = .scaleAspectFill
        movieImage.clipsToBounds = true
        imageIsChange = true
        dismiss(animated: true)
   }
}

    

