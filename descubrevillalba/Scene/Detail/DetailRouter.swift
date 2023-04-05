//
//  DetailRouter.swift
//  descubrevillalba
//
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol DetailRoutingLogic {
  func routeBack()
  func routeToGallery()
  func routeToVideos()
}

protocol DetailDataPassing {
  var dataStore: DetailDataStore? { get }
}

class DetailRouter: DetailRoutingLogic, DetailDataPassing {

  // MARK: - Properties

  weak var viewController: DetailViewController?
  var dataStore: DetailDataStore?

  // MARK: - Routing

  func routeBack() {
    viewController?.navigationController?.popViewController(animated: true)
  }
  
  func routeToGallery() {
    let destinationVC = GalleryViewController()
    if let sourceDS = dataStore, var destinationDS = destinationVC.router?.dataStore {
      destinationDS.monumentId = sourceDS.monumentId
    }
    viewController?.navigationController?.pushViewController(destinationVC, animated: true)
  }
  
  func routeToVideos() {
    let destinationVC = VideosViewController()
    if let sourceDS = dataStore, var destinationDS = destinationVC.router?.dataStore {
      destinationDS.monumentId = sourceDS.monumentId
    }
    viewController?.navigationController?.pushViewController(destinationVC, animated: true)
  }
}
