//
//  MovementPattern.swift
//  workshop
//
//  Created by Alan Perez on 6/6/21.
//

import Foundation

/// An exercise movement pattern executed as part of a workout for physical fitness and stimulating a muscle growth.
struct MovementPattern: Identifiable {
  let id: String
  let name: String
}

extension MovementPattern {
  static let benchPress = MovementPattern(id: "exc_bench_press", name: "Bench Press")
  static let squat = MovementPattern(id: "exc_squat", name: "Squat")
  static let shoulderPress = MovementPattern(id: "exc_shoulder_press", name: "Shoulder Press")
  static let deadlift = MovementPattern(id: "exc_deadlift", name: "Deadlift")
}
