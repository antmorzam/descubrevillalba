//
//  UIView.swift
//  descubrevillalba
//
//  Created by Antonio Moreno on 02/03/2022.
//

import Foundation
import UIKit
import CTPanoramaView
import FirebaseUI
extension UIView {

  func addSubviewForAutolayout(_ subview: UIView) {
    subview.translatesAutoresizingMaskIntoConstraints = false
    addSubview(subview)
  }
}

extension CTPanoramaView {
  
  func loadStorageImage(root: String, name: String) {
    let reference = StorageRef.storageRef?.child(root).child(name) ?? StorageReference()
    let placeholderImage = UIImage(named: ImageIdentifiers.placeholder)
    
    DispatchQueue.main.async {
      let imageView = UIImageView()
      imageView.sd_setImage(with: reference, placeholderImage: placeholderImage) {_,_,_,_ in
        self.image = imageView.image
      }
    }
  }
}
