//
//  Persistence.swift
//  Shared
//
//  Created by nissy on 2021/10/19.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        let stations = [["八草","高蔵寺"],["藤が丘","高畑"]]
        for station in stations {
            let newTimetable = Timetable(context: viewContext)
            newTimetable.timestamp = Date()
            newTimetable.name = station[0]
            newTimetable.direction = station[1]
            newTimetable.orditable = [[1,2],[4,6],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]]

        }
        
        let presets = [["行き道","八草"],["帰り道","藤が丘"]]
        let middset = [["八草"],["藤が丘"]]
        for (index,preset) in presets.enumerated() {
            let newPreset = Preset(context: viewContext)
            newPreset.name = preset[0]
            newPreset.start = preset[1]
            newPreset.middname = middset[index]
            newPreset.midddir = ["were"]
            newPreset.needtime = [10]
            newPreset.timestamp = Date()
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Tnorn")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                Typical reasons for an error here include:
                * The parent directory does not exist, cannot be created, or disallows writing.
                * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                * The device is out of space.
                * The store could not be migrated to the current model version.
                Check the error message to determine what the actual problem was.
                */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}
