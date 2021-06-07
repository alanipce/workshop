//
//  WorkoutLogView.swift
//  workshop
//
//  Created by Alan Perez on 6/6/21.
//

import SwiftUI

struct WorkoutLogView: View {
  let exercises: [MovementPattern] = [
    .benchPress,
    .squat,
    .shoulderPress,
    .deadlift
  ]
  
  private static let isTodayPredicate: NSPredicate = {
    // Get the current calendar with local time zone
    var calendar = Calendar.current
    // Get today's beginning & end
    let dateFrom = calendar.startOfDay(for: Date()) // eg. 2016-10-10 00:00:00
    let dateTo = calendar.date(byAdding: .day, value: 1, to: dateFrom)!

    // Set predicate as date being today's date
    let fromPredicate = NSPredicate(format: "timestamp >= %@", dateFrom as NSDate)
    let toPredicate = NSPredicate(format: "timestamp < %@", dateTo as NSDate)
    return NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate])
  }()
  
  @FetchRequest(
    sortDescriptors: [NSSortDescriptor(keyPath: \WorkoutLogEntry.timestamp, ascending: true)],
    predicate: Self.isTodayPredicate,
    animation: .default)
  private var items: FetchedResults<WorkoutLogEntry>
  
  var body: some View {
    ScrollView {
      VStack(alignment: .leading) {
        ForEach(exercises) { exercise in
          WorkoutInputView(exercise: exercise)
          WorkoutEntriesView(items: items.filter { $0.movementId == exercise.id })
        }
      }
    }
  }
}

struct WorkoutEntriesView: View {
  let items: [WorkoutLogEntry]
  
  private let loadFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.maximumFractionDigits = 2
    return formatter
  }()
  
  var body: some View {
    VStack {
      ForEach(items) { item in
        Text("\(NSNumber(value: item.load), formatter: loadFormatter) x \(item.reps)")
      }
    }
  }
}

struct WorkoutInputView: View {
  let exercise: MovementPattern
  
  @Environment(\.managedObjectContext) private var viewContext
  @State var load = ""
  @State var reps = ""
  
  var body: some View {
    HStack {
      Text(exercise.name)
      Spacer()
      TextField("Load", text: $load)
        .keyboardType(.numberPad)
        .frame(width: 60)
      TextField("Reps", text: $reps)
        .keyboardType(.numberPad)
        .frame(width: 50)
      Button {
        addItem()
      } label: {
        Text("Save")
      }
    }
  }
  
  private func addItem() {
    guard let loadValue = Float(load), let repValue = Int16(reps), loadValue > 0, repValue > 0 else {
      print("Attempted to save workout entry with invalid load or rep value.")
      return
    }
    
    withAnimation {
      let newItem = WorkoutLogEntry(context: viewContext)
      newItem.reps = repValue
      newItem.load = loadValue
      newItem.movementId = exercise.id
      newItem.timestamp = Date()
      
      do {
        try viewContext.save()
      } catch {
        let nsError = error as NSError
        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
      }
    }
  }
}

struct WorkoutLogView_Previews: PreviewProvider {
  static var previews: some View {
    WorkoutLogView()
      .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
  }
}
