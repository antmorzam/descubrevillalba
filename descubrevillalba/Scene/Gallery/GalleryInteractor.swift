//
//  GalleryInteractor.swift
//  descubrevillalba
//
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

protocol GalleryBusinessLogic {
  func doLoadData(request: Gallery.LoadData.Request)
  func doSelectedPhoto(request: Gallery.SelectedPhoto.Request)
}

protocol GalleryDataStore {
  var monumentId: String? { get set }
  var selectedPhoto: MonumentPhoto? { get set }
}

class GalleryInteractor: GalleryBusinessLogic, GalleryDataStore {

  var monumentId: String?
  var selectedPhoto: MonumentPhoto?
  var monumentPhotos: [MonumentPhoto] = []
  var monumentAPI: MonumentAPI?
  
  // MARK: - Properties

  var presenter: GalleryPresentationLogic?

  // MARK: - Public

  func doLoadData(request: Gallery.LoadData.Request) {
    guard let monumentId = monumentId else {
      return
    }
    presenter?.presentLoadData(response: Gallery.LoadData.Response(result: .loading))

    monumentAPI?.getPhotos(monumentId: monumentId) { [weak self] result in
      guard let self = self else {
        return
      }
      switch result {
      case .success(let monumentPhotos):
        self.monumentPhotos = monumentPhotos
        self.monumentPhotos.sort { $0.esPanorama && !$1.esPanorama }
        let response = Gallery.LoadData.Response(result: .success(data: self.monumentPhotos))
        self.presenter?.presentLoadData(response: response)
      case .failure(let error):
        let response = Gallery.LoadData.Response(result: .error(error))
        self.presenter?.presentLoadData(response: response)
      }
    }
  }

  func doSelectedPhoto(request: Gallery.SelectedPhoto.Request) {
    selectedPhoto = monumentPhotos[request.index]
    let response = Gallery.SelectedPhoto.Response()
    presenter?.presentSelectedPhoto(response: response)
  }
}
