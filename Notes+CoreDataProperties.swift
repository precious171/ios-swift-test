//
//  Notes+CoreDataProperties.swift
//  
//
//  Created by gHOST on 23/7/18.
//
//

import Foundation
import CoreData


extension Notes {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Notes> {
        return NSFetchRequest<Notes>(entityName: "Notes")
    }

    @NSManaged public var id: Int64
    @NSManaged public var creation_date: NSDate?
    @NSManaged public var last_modified: NSDate?
    @NSManaged public var title: String?
    @NSManaged public var detail: String?

}
