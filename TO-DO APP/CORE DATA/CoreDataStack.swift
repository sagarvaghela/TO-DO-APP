//
//  CoreDataStack.swift
//  TO-DO APP
//
//  Created by Sagar Vaghela on 10/09/18.
//  Copyright © 2018 Sagar Vaghela. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    var container: NSPersistentContainer {
        let container = NSPersistentContainer(name: "To_do")
        container.loadPersistentStores { (description, error) in
            guard error == nil else {
                print("\(error!)")
                return
            }
        }
    return container
    }
    
    var managedContex: NSManagedObjectContext {
        return container.viewContext
    }
}
