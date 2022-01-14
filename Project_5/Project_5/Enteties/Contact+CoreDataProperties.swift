//
//  Contact+CoreDataProperties.swift
//  Project_5
//
//  Created by Andria Kilasonia on 14.01.22.
//
//

import Foundation
import CoreData


extension Contact {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contact> {
        return NSFetchRequest<Contact>(entityName: "Contact")
    }

    @NSManaged public var name: String
    @NSManaged public var phoneNumber: String

}

extension Contact : Identifiable {

}
