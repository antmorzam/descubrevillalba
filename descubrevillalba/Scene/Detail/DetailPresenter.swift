//
//  DetailPresenter.swift
//  descubrevillalba
//
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

protocol DetailPresentationLogic {
  func presentLoadData(response: Detail.LoadData.Response)
  func presentAudioSelected(response: Detail.AudioSelected.Response)
}

class DetailPresenter: DetailPresentationLogic {

  // MARK: - Properties

  weak var viewController: DetailDisplayLogic?

  // MARK: - Public

  func presentLoadData(response: Detail.LoadData.Response) {
    let viewModel: Detail.LoadData.ViewModel
    switch response.result {
    case .loading:
      viewModel = Detail.LoadData.ViewModel(content: .loading)
    case .success(let data):
      let viewData = DetailViewData(imageUrl: data.mainImageUrl,
                                    title: data.name,
                                    description: data.description)
      viewModel = Detail.LoadData.ViewModel(content: .success(data: viewData))
    case .error(let error):
      viewModel = Detail.LoadData.ViewModel(content: .error(error.localizedDescription))
    case .invalidCode:
      viewModel = Detail.LoadData.ViewModel(content: .invalidCode)
    }

    viewController?.displayLoadData(viewModel: viewModel)
  }

  func presentAudioSelected(response: Detail.AudioSelected.Response) {
    let viewModel: Detail.AudioSelected.ViewModel
    switch response.result {
    case .loading:
      viewModel = Detail.AudioSelected.ViewModel(content: .loading)
    case .success(let data):
      let viewData = AudioItem(audioUrl: data.audioUrl,
                               imageUrl: data.imageUrl,
                               root: data.root)
      viewModel = Detail.AudioSelected.ViewModel(content: .success(data: viewData))
    case .error(let error):
      viewModel = Detail.AudioSelected.ViewModel(content: .error(error.localizedDescription))
    }
    viewController?.displayAudioSelected(viewModel: viewModel)
  }
}
