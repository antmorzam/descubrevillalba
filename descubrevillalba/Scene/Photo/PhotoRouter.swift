//
//  PhotoRouter.swift
//  descubrevillalba
//
//  Copyright © 2022 Antonio Moreno. All rights reserved.
//

import UIKit

protocol PhotoRoutingLogic {
  func routeBack()
}

protocol PhotoDataPassing {
  var dataStore: PhotoDataStore? { get }
}

class PhotoRouter: PhotoRoutingLogic, PhotoDataPassing {

  // MARK: - Properties

  weak var viewController: PhotoViewController?
  var dataStore: PhotoDataStore?

  // MARK: - Routing

  func routeBack() {
    viewController?.navigationController?.popViewController(animated: true)
  }
}
