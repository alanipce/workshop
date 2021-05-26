//
//  View+Keyboard.swift
//  workshop
//
//  Created by Alan Perez on 5/26/21.
//

import UIKit
import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
