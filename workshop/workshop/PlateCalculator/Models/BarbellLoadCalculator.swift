//
//  BarbellLoadCalculator.swift
//  workshop
//
//  Created by Alan Perez on 5/26/21.
//

import Foundation

/// A utility class for calculating the load to place on a barbell for a given goal.
class BarbellLoadCalculator {
  enum Error: Swift.Error {
    case loadOutOfBounds
  }
  
  private let maximumLoad: Float = 1_500
  private let minimumLoad: Float = 1
  let barbell: Barbell
  
  init(barbell: Barbell) {
    self.barbell = barbell
  }
  
  /// Calculates the optimal plate path to achieve the desired load. The results will be sorted from heaviest plate to lightest.
  ///
  /// - Returns: the plate configuration that uses the least amount of plates.
  func calculateOptimalPlateConfiguration(to load: Float, with plates: [Plate]) throws -> [Plate]? {
    let plateLoad = load - barbell.weight
    if plateLoad == 0 {
      return []
    }
    
    guard plateLoad <= maximumLoad && plateLoad >= minimumLoad else { throw Error.loadOutOfBounds }
    
    let orderedPlates = plates.sorted { $0.weight > $1.weight }
    return findOptimalPath(to: plateLoad, with: orderedPlates)?.sorted { $0.weight > $1.weight }
  }
  
  private func findOptimalPath(to load: Float, with orderedPlates: [Plate]) -> [Plate]? {
    if load == 0 {
      return []
    }
    
    if load < 0 {
      return nil
    }
    
    if orderedPlates.isEmpty {
      return nil
    }
    
    // Take two paths to find optimal configuration and compare their optiomal paths to find the
    // smaller option.
    // 1. take one of the heaviest plate and compute the remaining load using the remaining plates
    // 2. Attempt to reach load without the heaviest plate
    var remainingPlates = orderedPlates
    let heaviestPlate = remainingPlates.remove(at: 0)
    
    var optimalPath1 = findOptimalPath(to: load - heaviestPlate.weight, with: remainingPlates)
    optimalPath1?.append(heaviestPlate)
    
    let optimalPath2 = findOptimalPath(to: load, with: orderedPlates.filter { $0 != heaviestPlate })

    if optimalPath1 == nil && optimalPath2 == nil {
      return nil
    }

    let foundPaths = [optimalPath1, optimalPath2].compactMap { $0 }
    if foundPaths.isEmpty {
      return nil
    }
    
    return foundPaths.sorted { $0.count < $1.count }[0]
  }
}
