//
//  HowToWorkRouter.swift
//  descubrevillalba
//
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol HowToWorkRoutingLogic {
  func routeBack()
}

protocol HowToWorkDataPassing {
  var dataStore: HowToWorkDataStore? { get }
}

class HowToWorkRouter: HowToWorkRoutingLogic, HowToWorkDataPassing {

  // MARK: - Properties

  weak var viewController: HowToWorkViewController?
  var dataStore: HowToWorkDataStore?

  // MARK: - Routing

  func routeBack() {
    if let destinationVC = viewController?.navigationController?.viewControllers.first, destinationVC is StartViewController {
      if let sourceDS = dataStore, var destinationDS = (destinationVC as! StartViewController).router?.dataStore {
        destinationDS.isChangedLanguage = sourceDS.isChangedLanguage
      }
      viewController?.navigationController?.popToViewController(destinationVC, animated: true)
    } else {
      viewController?.navigationController?.popViewController(animated: true)
    }
  }
}
