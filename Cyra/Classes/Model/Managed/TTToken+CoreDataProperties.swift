//
//  TTToken+CoreDataProperties.swift
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

extension TTToken {

    @NSManaged var accessToken: String!
    @NSManaged var expiresIn: NSNumber!
    @NSManaged var expiresAt: NSDate!
    @NSManaged var type: String!
    @NSManaged var scope: String!
    @NSManaged var user: TTUser?

}
