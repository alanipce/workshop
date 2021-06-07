//
//  ContentView.swift
//  workshop
//
//  Created by Alan Perez on 5/26/21.
//

import SwiftUI
import CoreData

struct ContentView: View {
  var body: some View {
    NavigationView {
      WorkoutLogView()
        .navigationTitle("Workout log")
        .toolbar {
          NavigationLink(
            "Plate Calculator",
            destination: PlateCalculatorView().navigationTitle("Plate Calculator")
          )
        }
        .padding()
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
