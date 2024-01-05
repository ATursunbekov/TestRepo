//
//  StorageManager.swift
//  TestingUI
//
//  Created by Alikhan Tursunbekov on 3/1/24.
//

import UIKit
import CoreData

//MARK: CRUD Create Read Update Delete

public final class CoreDataManager: NSObject {
    public static let shared = CoreDataManager()
    private override init() {}
    
    private var appDelegate : AppDelegate {
        UIApplication.shared.delegate as! AppDelegate
    }
    
    private var context: NSManagedObjectContext {
        appDelegate.persistentContainer.viewContext
    }
    
    public func createPhoto(id: Int16, title: String, url: String?) {
        guard let photoEntityDescription = NSEntityDescription.entity(forEntityName: "Photo", in: context) else {return}
        let photo = Photo(entity: photoEntityDescription, insertInto: context)
        photo.id = id
        photo.title = title
        photo.url = url
        
        appDelegate.saveContext()
    }
    
    public func fetchPhotos() -> [Photo] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Photo")
        do {
            return (try? context.fetch(fetchRequest) as? [Photo]) ?? []
        }
    }
    
    public func fetchPhoto(id: Int16) -> Photo? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Photo")
        do {
            let photos = try? context.fetch(fetchRequest) as? [Photo]
            return photos?.first(where: { $0.id == id})
        }
    }
    
    public func updatePhoto(with id: Int16, newUrl: String, title: String? = nil) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Photo")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id) // finding object via SQL
        do {
            guard let photos = try? context.fetch(fetchRequest) as? [Photo], let photo = photos.first else {return}
            photo.id = id
            photo.url = newUrl
            photo.title = title
        }
        appDelegate.saveContext()
    }
    
    public func deleteAllPhotos() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Photo")
        do {
            let photos = try? context.fetch(fetchRequest) as? [Photo]
            photos?.forEach({context.delete($0)})
        }
        appDelegate.saveContext()
    }
    
    public func deletePhoto(id: Int16) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Photo")
        do {
            guard let photos = try? context.fetch(fetchRequest) as? [Photo], let photo = photos.first(where: { $0.id == id}) else {return}
            context.delete(photo)
        }
        appDelegate.saveContext()
    }
}
