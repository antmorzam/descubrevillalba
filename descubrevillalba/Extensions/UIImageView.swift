//
//  UIImageView.swift
//  descubrevillalba
//
//  Created by Antonio Moreno on 19/03/2022.
//

import Foundation
import FirebaseUI

struct StorageRef {
    static var storageRef: StorageReference?
}

extension UIImageView {

  func loadStorageImage(root: String, name: String) {
    let reference = StorageRef.storageRef?.child(root).child(name) ?? StorageReference()
    let placeholderImage = UIImage(named: ImageIdentifiers.placeholder)
    
    DispatchQueue.main.async {
      self.sd_setImage(with: reference, placeholderImage: placeholderImage)
    }
  }
}
