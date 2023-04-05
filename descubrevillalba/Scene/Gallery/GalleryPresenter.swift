//
//  GalleryPresenter.swift
//  descubrevillalba
//
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

protocol GalleryPresentationLogic {
  func presentLoadData(response: Gallery.LoadData.Response)
  func presentSelectedPhoto(response: Gallery.SelectedPhoto.Response)
}

class GalleryPresenter: GalleryPresentationLogic {

  // MARK: - Properties

  weak var viewController: GalleryDisplayLogic?

  // MARK: - Public

  func presentLoadData(response: Gallery.LoadData.Response) {
    switch response.result {
    case .loading:
      viewController?.displayLoadData(viewModel: Gallery.LoadData.ViewModel(content: .loading))
    case .success(let data):
      var listViewData: [ListViewCellData] = []
      data.forEach { photo in
        listViewData.append(ListViewCellData(identifier: String(photo.identifier),
                                             imageUrl: photo.photoUrl,
                                             title: "",
                                             esPanorama: photo.esPanorama))
      }
      let viewModel = Gallery.LoadData.ViewModel(content: .success(data: listViewData))
      viewController?.displayLoadData(viewModel: viewModel)
    case .error(let error):
      viewController?.displayLoadData(viewModel: Gallery.LoadData.ViewModel(content: .error(message: error.localizedDescription)))
    }
  }
  
  func presentSelectedPhoto(response: Gallery.SelectedPhoto.Response) {
    let viewModel = Gallery.SelectedPhoto.ViewModel()
    viewController?.displaySelectedPhoto(response: viewModel)
  }
}
