//
//  VideosPresenter.swift
//  descubrevillalba
//
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

protocol VideosPresentationLogic {
  func presentLoadData(response: Videos.LoadData.Response)
  func presentSelectedItem(response: Videos.SelectedItem.Response)
}

class VideosPresenter: VideosPresentationLogic {

  // MARK: - Properties

  weak var viewController: VideosDisplayLogic?

  // MARK: - Public

  func presentLoadData(response: Videos.LoadData.Response) {
    switch response.result {
    case .loading:
      viewController?.displayLoadData(viewModel: Videos.LoadData.ViewModel(content: .loading))
    case .success(let data):
      let viewData: [VideosViewData] = data.map({ video in
        VideosViewData(identifier: video.identifier, title: video.name)
      })
      let viewModel = Videos.LoadData.ViewModel(content: .success(data: viewData))
      viewController?.displayLoadData(viewModel: viewModel)
    case .error(let error):
      viewController?.displayLoadData(viewModel: Videos.LoadData.ViewModel(content: .error(message: error.localizedDescription)))
    }
  }
  
  func presentSelectedItem(response: Videos.SelectedItem.Response) {
    let viewModel = Videos.SelectedItem.ViewModel(video: response.video)
    viewController?.displaySelectedItem(viewModel: viewModel)
  }

  // MARK: - Private
}
