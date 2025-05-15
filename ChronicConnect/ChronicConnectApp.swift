//
//  ChronicConnectApp.swift
//  ChronicConnect
//
//  Created by Supriya KR on 5/10/25.
//

import SwiftUI

@main
struct ChronicConnectApp: App {
    // Use our CoreDataStack for data persistence
    let coreDataStack = CoreDataStack.shared
    
    init() {
        // Generate sample data when the app first launches
        // In a real app, you would only do this once or when needed
        #if DEBUG
        coreDataStack.generateSampleData()
        #endif
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, coreDataStack.viewContext)
        }
    }
}
