//
//  GalleryRouter.swift
//  descubrevillalba
//
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol GalleryRoutingLogic {
  func routeBack()
  func navigateToPhoto()
}

protocol GalleryDataPassing {
  var dataStore: GalleryDataStore? { get }
}

class GalleryRouter: GalleryRoutingLogic, GalleryDataPassing {

  // MARK: - Properties

  weak var viewController: GalleryViewController?
  var dataStore: GalleryDataStore?

  // MARK: - Routing

  func routeBack() {
    viewController?.navigationController?.popViewController(animated: true)
  }
  
  func navigateToPhoto() {
    let destinationVC = PhotoViewController()
    if let sourceDS = dataStore, var destinationDS = destinationVC.router?.dataStore {
      destinationDS.selectedPhoto = sourceDS.selectedPhoto
    }
    viewController?.navigationController?.pushViewController(destinationVC, animated: true)
  }
}
