//
//  Timetable+CoreDataProperties.swift
//  norn
//
//  Created by nissy on 2021/10/18.
//
//

import Foundation
import CoreData


extension Timetable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Timetable> {
        return NSFetchRequest<Timetable>(entityName: "Timetable")
    }

    @NSManaged public var direction: String?
    @NSManaged public var holitable: Int16
    @NSManaged public var name: String?
    @NSManaged public var ordinarytable: Int16
    @NSManaged public var saturdaytable: Int16
    @NSManaged public var timestamp: Date?

}

extension Timetable : Identifiable {

}
