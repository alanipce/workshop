//
//  workshopApp.swift
//  workshop
//
//  Created by Alan Perez on 5/26/21.
//

import SwiftUI

@main
struct WorkshopApp: App {
  let persistenceController = PersistenceController.shared
  
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environment(\.managedObjectContext, persistenceController.container.viewContext)
    }
  }
}
