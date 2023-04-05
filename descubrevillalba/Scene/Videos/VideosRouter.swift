//
//  VideosRouter.swift
//  descubrevillalba
//
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol VideosRoutingLogic {
  func routeBack()
}

protocol VideosDataPassing {
  var dataStore: VideosDataStore? { get }
}

class VideosRouter: VideosRoutingLogic, VideosDataPassing {

  // MARK: - Properties

  weak var viewController: VideosViewController?
  var dataStore: VideosDataStore?

  // MARK: - Routing

  func routeBack() {
    viewController?.navigationController?.popViewController(animated: true)
  }
}
