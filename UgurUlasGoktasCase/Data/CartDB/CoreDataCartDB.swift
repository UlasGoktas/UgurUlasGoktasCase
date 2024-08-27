//
//  CoreDataCartDB.swift
//  UgurUlasGoktasCase
//
//  Created by Ulas Goktas on 27.08.2024.
//

import CoreData
import UIKit

class CoreDataCartDB: CartDBStrategy {
    private let context: NSManagedObjectContext
    private let entityName = "CartItem"

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
                price: $0.value(forKey: ProductKeys.price.rawValue) as? String,
                quantity: $0.value(forKey: ProductKeys.quantity.rawValue) as? Int
            )
        }
    }
    
    func delete(product: Product) throws {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "id == %@", product.id ?? "")

        let objects = try context.fetch(fetchRequest) as? [NSManagedObject]
        
        if let cartItem = objects?.first {
            context.delete(cartItem)
            try context.save()
        }
    }

    func add(product: Product) throws {
        guard let entity = NSEntityDescription.entity(forEntityName: entityName, in: context) else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: TextConstants.entityNotFound.rawValue])
        }
        let cartItem = NSManagedObject(entity: entity, insertInto: context)
        
        cartItem.setValue(product.brand, forKey: ProductKeys.brand.rawValue)
        cartItem.setValue(product.createdAt, forKey: ProductKeys.createdAt.rawValue)
        cartItem.setValue(product.description, forKey: ProductKeys.description.rawValue)
        cartItem.setValue(product.id, forKey: ProductKeys.id.rawValue)
        cartItem.setValue(product.image, forKey: ProductKeys.image.rawValue)
        cartItem.setValue(product.model, forKey: ProductKeys.model.rawValue)
        cartItem.setValue(product.name, forKey: ProductKeys.name.rawValue)
        cartItem.setValue(product.price, forKey: ProductKeys.price.rawValue)
        cartItem.setValue(product.quantity, forKey: ProductKeys.quantity.rawValue)

        try context.save()
    }

    func update(product: Product) throws {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "id == %@", product.id ?? "")

        let objects = try context.fetch(fetchRequest) as? [NSManagedObject]
        
        if let cartItem = objects?.first {
            cartItem.setValue(product.quantity, forKey: ProductKeys.quantity.rawValue)
            try context.save()
        }
    }
}
