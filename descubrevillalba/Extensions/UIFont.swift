//
//  UIFont.swift
//  descubrevillalba
//
//  Created by Antonio Moreno on 07/03/2022.
//

import UIKit

extension UIFont {

  enum DP: String {
    case regular = "Helvetica"
    case bold = "Helvetica-Bold"
    case light = "Helvetica-Light"
  }

  static func dpFont(_ font: DP, ofSize size: CGFloat) -> UIFont {
    UIFont(name: font.rawValue, size: size) ?? systemFont(ofSize: size)
  }
}
