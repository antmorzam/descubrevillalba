//
//  StartRouter.swift
//  descubrevillalba
//
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol StartRoutingLogic {
  func routeBack()
  func navigateToQr()
  func navigateToList()
  func navigateToHowToWork()
}

protocol StartDataPassing {
  var dataStore: StartDataStore? { get }
}

class StartRouter: StartRoutingLogic, StartDataPassing {

  // MARK: - Properties

  weak var viewController: StartViewController?
  var dataStore: StartDataStore?

  // MARK: - Routing

  func routeBack() {
    viewController?.navigationController?.popViewController(animated: true)
  }
  
  func navigateToQr() {
    let destinationVC = ScannerViewController()
    viewController?.navigationController?.pushViewController(destinationVC, animated: true)
  }
  
  func navigateToList() {
    let destinationVC = ListViewController()
    viewController?.navigationController?.pushViewController(destinationVC, animated: true)
  }
  
  func navigateToHowToWork() {
    let destinationVC = HowToWorkViewController()
    viewController?.navigationController?.pushViewController(destinationVC, animated: true)
  }
}
