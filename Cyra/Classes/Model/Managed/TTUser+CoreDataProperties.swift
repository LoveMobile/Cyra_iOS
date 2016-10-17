//
//  TTUser+CoreDataProperties.swift
//  
//
//  Created by Piotr on 01.08.2016.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension TTUser {

    @NSManaged var login: String?
    @NSManaged var password: String?
    @NSManaged var token: TTToken?

}
