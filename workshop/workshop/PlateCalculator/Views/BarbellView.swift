//
//  BarbellView.swift
//  workshop
//
//  Created by Alan Perez on 5/26/21.
//

import SwiftUI

struct BarbellView: View {
  let barColor: Color = .gray
  @Binding var plates: [Plate]
  
  var body: some View {
    GeometryReader { metrics in
      HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 0) {
        Rectangle()
          .foregroundColor(barColor)
          .frame(maxWidth: metrics.size.width * 0.35, maxHeight: 30)
        Rectangle()
          .foregroundColor(barColor)
          .frame(width: 25, height: 60)
        ForEach(plates, id: \.self) { plate in
          ZStack {
            Rectangle()
              .foregroundColor(plateColor(plate))
              .cornerRadius(5)
              .frame(width: 40 * CGFloat(min(plateProportion(plate), 1)), height: 200 * CGFloat(min(plateProportion(plate), 1)))
            Text(plateWeight(plate))
              .foregroundColor(.white)
              .fontWeight(.bold)
              .rotationEffect(Angle(degrees: 90))
          }
        }
        Rectangle()
          .foregroundColor(barColor)
          .frame(height: 30)
      }
    }
  }
  
  private func plateProportion(_ plate: Plate) -> Float {
    switch plate {
    case .p45, .p35, .p25, .p10:
      return 1
    case .p5, .p2_5:
      return 0.5
    }
  }
  
  private func plateWeight(_ plate: Plate) -> String {
    let numberFormatter = NumberFormatter()
    numberFormatter.maximumFractionDigits = 1
    return numberFormatter.string(for: plate.weight) ?? ""
  }
  
  private func plateColor(_ plate: Plate) -> Color {
    switch plate {
    case .p45:
      return .red
    case .p35:
      return .blue
    case .p25:
      return .yellow
    case .p10:
      return .green
    case .p5, .p2_5:
      return .gray
    }
  }
}

struct BarbellView_Previews: PreviewProvider {
  @State static var plates: [Plate] = [.p45, .p35, .p25, .p10, .p5, .p2_5]
  
  static var previews: some View {
    BarbellView(plates: $plates)
  }
}
