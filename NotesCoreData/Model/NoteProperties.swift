//
//  NoteProperties.swift
//  NotesCoreData
//
//  Created by Kiran on 12/09/22.
//

import Foundation
import CoreData

@objc(Note)
public class Note: NSManagedObject, Identifiable {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var date: Date!
    @NSManaged public var id: String!
    @NSManaged public var body: String!
    @NSManaged public var title: String!
    @NSManaged public var image: Data!
}





