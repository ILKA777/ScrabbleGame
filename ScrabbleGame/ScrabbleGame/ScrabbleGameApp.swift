//
//  ScrabbleGameApp.swift
//  ScrabbleGame
//
//  Created by Илья on 08.06.2024.
//

import SwiftUI

@main
struct ScrabbleGameApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
