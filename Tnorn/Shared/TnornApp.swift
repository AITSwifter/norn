//
//  TnornApp.swift
//  Shared
//
//  Created by nissy on 2021/10/19.
//

import SwiftUI

@main
struct TnornApp: App {
    let persistenceController = PersistenceController.shared.managedObjectContext

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController)
        }
    }
}
