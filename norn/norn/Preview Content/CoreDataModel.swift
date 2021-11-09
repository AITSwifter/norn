//
//  CoreDataModel.swift
//  norn
//
//  Created by nissy on 2021/10/18.
//

import Foundation
import CoreData
import UIKit

class CoreDataModel {
    private static var persistentContainer: NSPersistentCloudKitContainer! = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
}

static func newTimeTable() -> Timetable {
    let context = persistentContainer.viewContext
    let person = NSEntityDescription.insertNewObject(forEntityName: "Timetable", into: context) as! Person
    return person
}

static func newMyTable() -> Mytable {
    let context = persistentContainer.viewContext
    let career = NSEntityDescription.insertNewObject(forEntityName: "Career", into: context) as! Career
    person.addToCareers(career)
    return career
}
