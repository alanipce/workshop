//
//  BarbellView.swift
//  workshop
//
//  Created by Alan Perez on 5/26/21.
//

import SwiftUI

struct BarbellView: View {
  private let barColor: Color = .gray
  private let maxBarbellHeight: CGFloat = 200
  @Binding var barbell: Barbell
  @Binding var plates: [Plate]
  
  var body: some View {
    GeometryReader { metrics in
      HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 0) {
        ZStack {
          Rectangle()
            .foregroundColor(barColor)
            .frame(maxWidth: metrics.size.width * 0.35, maxHeight: 30)
          Text(formatWeight(barbell.weight))
            .foregroundColor(.white)
            .fontWeight(.bold)
            .fixedSize()
            .lineLimit(1)
        }
        Rectangle()
          .foregroundColor(barColor)
          .frame(width: 25, height: 60)
        ForEach(plates, id: \.self) { plate in
          ZStack {
            Rectangle()
              .foregroundColor(plateColor(plate))
              .cornerRadius(5)
            Text(formatWeight(plate.weight))
              .foregroundColor(.white)
              .fontWeight(.bold)
              .fixedSize()
              .lineLimit(1)
              .rotationEffect(Angle(degrees: 90))
          }
          .frame(
            width: 40,
            height: maxBarbellHeight
          )
        }
        Rectangle()
          .foregroundColor(barColor)
          .frame(height: 30)
      }
      .frame(maxWidth: 800, minHeight: maxBarbellHeight)
    }
  }
  
  private func formatWeight(_ weight: Float) -> String {
    let numberFormatter = NumberFormatter()
    numberFormatter.maximumFractionDigits = 1
    return numberFormatter.string(for: weight)!
  }
  
  private func plateColor(_ plate: Plate) -> Color {
    switch plate {
    case .p45:
      return .red
    case .p35:
      return .blue
    case .p25:
      return .yellow
    case .p15:
      return .green
    case .p10, .p5, .p2_5:
      return .black
    }
  }
}

struct BarbellView_Previews: PreviewProvider {
  @State static var plates: [Plate] = [.p45, .p35, .p25, .p10, .p5, .p2_5]
  @State static var barbell: Barbell = .standard
  
  static var previews: some View {
    BarbellView(barbell: $barbell, plates: $plates)
  }
}
