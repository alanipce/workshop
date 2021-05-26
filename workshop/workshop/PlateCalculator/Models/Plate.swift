//
//  Plate.swift
//  workshop
//
//  Created by Alan Perez on 5/26/21.
//

import Foundation

/// Represents a standard plate and its various characteristics.
enum Plate: Equatable {
  case p45
  case p35
  case p25
  case p10
  case p5
  case p2_5
  
  /// The weight of the plate. In lbs units repesented using floating point since all values are representable as machine numbers.
  var weight: Float {
    switch self {
    case .p45:
      return 45
    case .p35:
      return 35
    case .p25:
      return 25
    case .p10:
      return 10
    case .p5:
      return 5
    case .p2_5:
      return 2.5
    }
  }
}
