//
//  PhotoInteractor.swift
//  descubrevillalba
//
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

protocol PhotoBusinessLogic {
  func doLoadStaticData(request: Photo.StaticData.Request)
}

protocol PhotoDataStore {
  var selectedPhoto: MonumentPhoto? { get set }
}

class PhotoInteractor: PhotoBusinessLogic, PhotoDataStore {

  var selectedPhoto: MonumentPhoto?

  // MARK: - Properties

  var presenter: PhotoPresentationLogic?

  // MARK: - Public

  func doLoadStaticData(request: Photo.StaticData.Request) {
    guard let selectedPhoto = selectedPhoto else {
      return
    }
    let response = Photo.StaticData.Response(result: selectedPhoto)
    presenter?.presentStaticData(response: response)
  }
}
