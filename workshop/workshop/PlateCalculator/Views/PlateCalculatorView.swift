//
//  PlateCalculatorView.swift
//  workshop
//
//  Created by Alan Perez on 5/26/21.
//

import SwiftUI

struct PlateCalculatorView: View {
  @State var plates = [Plate]()
  @State var loadInput = ""
  
  /// TODO: remove hardcoded values matching my current setup
  private let plateInventory: [Plate] = [
    .p45,
    .p45,
    .p45,
    .p35,
    .p25,
    .p15,
    .p10,
    .p5,
    .p2_5
  ]
  
  private let barbellCalculator = BarbellLoadCalculator(barbell: .standard)
  
  var body: some View {
    VStack {
      TextField("How much you lifting?", text: $loadInput)
        .keyboardType(.numberPad)
        .padding()
      Button(action: {
        calculateOptimalPlateConfiguration()
      }, label: {
        Text("Calculate")
          .padding(.all, 10)
          .font(.system(size: 18))
          .foregroundColor(.white)
          .background(Color.blue)
          .clipShape(RoundedRectangle(cornerRadius: 8))
                
      })
      Spacer(minLength: 100)
      BarbellView(plates: $plates)
    }
  }
  
  private func calculateOptimalPlateConfiguration() {
    guard let load = Float(loadInput) else {
      // TODO: improve input error handling
      return
    }
    do {
      let result = try barbellCalculator.calculateOptimalPlateConfiguration(to: load, with: plateInventory)
      
      guard let optimalResult = result else {
        // TODO: improve input error handling
        return
      }
      
      hideKeyboard()
      plates = optimalResult
    } catch {
      // TODO: imrove input error handling
    }
  }
}

struct PlateCalculatorView_Previews: PreviewProvider {
  static var previews: some View {
    PlateCalculatorView()
  }
}
