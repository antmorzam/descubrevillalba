//
//  ListRouter.swift
//  descubrevillalba
//
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol ListRoutingLogic {
  func routeBack()
}

protocol ListDataPassing {
  var dataStore: ListDataStore? { get }
}

class ListRouter: ListRoutingLogic, ListDataPassing {

  // MARK: - Properties

  weak var viewController: ListViewController?
  var dataStore: ListDataStore?

  // MARK: - Routing

  func routeBack() {
    viewController?.navigationController?.popViewController(animated: true)
  }
}
