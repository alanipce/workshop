//
//  Barbell.swift
//  workshop
//
//  Created by Alan Perez on 5/26/21.
//

import Foundation

/// Represents a standard barbell and its various characteristics.
enum Barbell {
  case standard
  
  /// The weight of the barbell. In lbs units repesented using floating point since all values are representable as machine numbers.
  var weight: Float {
    switch self {
    case .standard:
      return 45
    }
  }
}
