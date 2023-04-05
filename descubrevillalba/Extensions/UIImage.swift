//
//  UIImage.swift
//  descubrevillalba
//
//  Created by Antonio Moreno on 03/03/2022.
//

import Foundation
import UIKit

extension UIImage {
  
  func resizeTo(size imageSize: CGFloat) -> UIImage? {
    (size.width >= size.height) ? resizeTo(width: imageSize) : resizeTo(height: imageSize)
  }

  func resizeTo(height: CGFloat) -> UIImage? {
    let width = height * size.width / size.height
    return resizeTo(width: width)
  }
  
  func resizeTo(width: CGFloat) -> UIImage? {
    let calculatedSize = CGSize(width: width, height: CGFloat(ceil(width / size.width * size.height)))
    let imageView = UIImageView(frame: CGRect(origin: .zero, size: calculatedSize))
    imageView.contentMode = .scaleAspectFit
    imageView.image = self
    UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
    guard let context = UIGraphicsGetCurrentContext() else {
      return nil
    }
    imageView.layer.render(in: context)
    guard let result = UIGraphicsGetImageFromCurrentImageContext() else {
      return nil
    }
    UIGraphicsEndImageContext()
    return result
  }
}
