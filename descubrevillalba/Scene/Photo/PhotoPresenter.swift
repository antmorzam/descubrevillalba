//
//  PhotoPresenter.swift
//  descubrevillalba
//
//  Copyright © 2022 Antonio Moreno. All rights reserved.
//

import Foundation

protocol PhotoPresentationLogic {
  func presentStaticData(response: Photo.StaticData.Response)
}

class PhotoPresenter: PhotoPresentationLogic {

  // MARK: - Properties

  weak var viewController: PhotoDisplayLogic?

  // MARK: - Public

  func presentStaticData(response: Photo.StaticData.Response) {
    let viewModel = Photo.StaticData.ViewModel(content: PhotoViewData(esPanorama: response.result.esPanorama,
                                                                      url: response.result.photoUrl))
    viewController?.displayStaticData(viewModel: viewModel)
  }

  // MARK: - Private
}
