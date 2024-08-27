//
//  CoreDataFavoriteDB.swift
//  UgurUlasGoktasCase
//
//  Created by Ulas Goktas on 27.08.2024.
//

import UIKit
import CoreData

class CoreDataFavoriteDB: FavoriteDBStrategy {
    private let context: NSManagedObjectContext
    private let entityName = "FavoriteItem"

    init(context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext) {
        self.context = context
    }
    
    func fetchProductList() throws -> [Product]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let result = try context.fetch(fetchRequest) as? [NSManagedObject] ?? []

        return result.map {
            Product(
                brand: $0.value(forKey: ProductKeys.brand.rawValue) as? String,
                createdAt: $0.value(forKey: ProductKeys.createdAt.rawValue) as? String,
                description: $0.value(forKey: ProductKeys.description.rawValue) as? String,
                id: $0.value(forKey: ProductKeys.id.rawValue) as? String,
                image: $0.value(forKey: ProductKeys.image.rawValue) as? String,
                model: $0.value(forKey: ProductKeys.model.rawValue) as? String,
                name: $0.value(forKey: ProductKeys.name.rawValue) as? String,
                price: $0.value(forKey: ProductKeys.price.rawValue) as? String
            )
        }
    }

    func add(product: Product) throws {
        guard let entity = NSEntityDescription.entity(forEntityName: entityName, in: context) else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: TextConstants.entityNotFound.rawValue])
        }
        let favoriteItem = NSManagedObject(entity: entity, insertInto: context)

        favoriteItem.setValue(product.brand, forKey: ProductKeys.brand.rawValue)
        favoriteItem.setValue(product.createdAt, forKey: ProductKeys.createdAt.rawValue)
        favoriteItem.setValue(product.description, forKey: ProductKeys.description.rawValue)
        favoriteItem.setValue(product.id, forKey: ProductKeys.id.rawValue)
        favoriteItem.setValue(product.image, forKey: ProductKeys.image.rawValue)
        favoriteItem.setValue(product.model, forKey: ProductKeys.model.rawValue)
        favoriteItem.setValue(product.name, forKey: ProductKeys.name.rawValue)
        favoriteItem.setValue(product.price, forKey: ProductKeys.price.rawValue)

        try context.save()
    }

    func delete(product: Product) throws {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "id == %@", product.id ?? "")

        let objects = try context.fetch(fetchRequest) as? [NSManagedObject]
        
        if let objects = objects, !objects.isEmpty {
            objects.forEach { context.delete($0) }
            try context.save()
        }
    }
}
