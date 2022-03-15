//
//  StorageManager.swift
//  MoviesList
//
//  Created by Aleksandra on 16.01.2022.
//


import RealmSwift

let realm = try! Realm()

class StorageManager {
    
    static func saveObject (_ movie: Object) {
        try! realm.write { realm.add(movie) }
    }
    
    static func deleteObject (_ movie: Object) {
        try! realm.write { realm.delete(movie) }
    }
}

