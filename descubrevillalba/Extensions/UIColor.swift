//
//  UIColor.swift
//  descubrevillalba
//
//  Created by Antonio Moreno on 07/03/2022.
//

import Foundation
import UIKit

extension UIColor {

  static func create(named name: String) -> UIColor {
    UIColor(named: name) ?? .black
  }
  
  func hexString() -> String {
    var red: CGFloat = 0
    var green: CGFloat = 0
    var blue: CGFloat = 0
    var alpha: CGFloat = 0

    getRed(&red, green: &green, blue: &blue, alpha: &alpha)

    let rgb: Int = Int(red * 255) << 16 | Int(green * 255) << 8 | Int(blue * 255) << 0
    return String(format: "#%06x", rgb)
  }
}
