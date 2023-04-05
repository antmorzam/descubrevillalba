//
//  ScannerRouter.swift
//  descubrevillalba
//
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol ScannerRoutingLogic {
  func routeBack()
  func routeToDetail()
}

protocol ScannerDataPassing {
  var dataStore: ScannerDataStore? { get }
}

class ScannerRouter: ScannerRoutingLogic, ScannerDataPassing {

  // MARK: - Properties

  weak var viewController: ScannerViewController?
  var dataStore: ScannerDataStore?

  // MARK: - Routing

  func routeBack() {
    viewController?.navigationController?.popViewController(animated: true)
  }
  
  func routeToDetail() {
    let destinationVC = DetailViewController()
    if let sourceDS = dataStore, var destinationDS = destinationVC.router?.dataStore {
      destinationDS.monumentId = sourceDS.monumentId
    }
    viewController?.navigationController?.pushViewController(destinationVC, animated: true)
  }
}
