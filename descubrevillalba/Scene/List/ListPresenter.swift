//
//  ListPresenter.swift
//  descubrevillalba
//
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

protocol ListPresentationLogic {
  func presentLoadData(response: List.LoadData.Response)
  func presentSelectedItem(response: List.SelectedItem.Response)
}

class ListPresenter: ListPresentationLogic {

  // MARK: - Properties

  weak var viewController: ListDisplayLogic?

  // MARK: - Public
  
  func presentLoadData(response: List.LoadData.Response) {
    switch response.result {
    case .loading:
      viewController?.displayLoadData(viewModel: List.LoadData.ViewModel(content: .loading))
    case .success(let data):
      let listViewData: [ListViewCellData] = data.map { monument in
        ListViewCellData(identifier: monument.identifier,
                         imageUrl: monument.cellImageUrl,
                         title: monument.name,
                         esPanorama: false)
      }
      let viewModel = List.LoadData.ViewModel(content: .success(data: listViewData))
      viewController?.displayLoadData(viewModel: viewModel)
    case .error(let error):
      viewController?.displayLoadData(viewModel: List.LoadData.ViewModel(content: .error(message: error.localizedDescription)))
    }
  }
  
  func presentSelectedItem(response: List.SelectedItem.Response) {
    let viewModel = List.SelectedItem.ViewModel(monumentId: response.monumentId, address: response.address)
    viewController?.displaySelectedItem(response: viewModel)
  }

  // MARK: - Private
}
