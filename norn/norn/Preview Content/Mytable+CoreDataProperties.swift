//
//  Mytable+CoreDataProperties.swift
//  norn
//
//  Created by nissy on 2021/10/18.
//
//

import Foundation
import CoreData


extension Mytable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Mytable> {
        return NSFetchRequest<Mytable>(entityName: "Mytable")
    }

    @NSManaged public var arrivel: String?
    @NSManaged public var departure: String?
    @NSManaged public var middle: String?
    @NSManaged public var name: String?
    @NSManaged public var needtime: Int16
    @NSManaged public var timestamp: Date?

}

extension Mytable : Identifiable {

}
