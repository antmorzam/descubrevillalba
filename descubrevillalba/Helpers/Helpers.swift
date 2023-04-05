//
//  Devices.swift
//  descubrevillalba
//
//  Created by Antonio Moreno on 07/03/2022.
//

import Foundation
import UIKit

struct ScreenSize {
  static let width = UIScreen.main.bounds.width
  static let height = UIScreen.main.bounds.height
  static let maxLength = max(ScreenSize.width, ScreenSize.height)
  static let minLength = min(ScreenSize.width, ScreenSize.height)
}
