//
//  ListInteractor.swift
//  descubrevillalba
//
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

protocol ListBusinessLogic {
  func doLoadData(request: List.LoadData.Request)
  func doSelectedItem(request: List.SelectedItem.Request)
}

protocol ListDataStore {
}

class ListInteractor: ListBusinessLogic, ListDataStore {

  // MARK: - Properties

  var presenter: ListPresentationLogic?
  var monumentAPI: MonumentAPI?
  var monuments: [MonumentDetails] = []

  // MARK: - Public

  func doLoadData(request: List.LoadData.Request) {
    presenter?.presentLoadData(response: List.LoadData.Response(result: .loading))
    monumentAPI?.getMonuments() { [weak self] result in
      guard let self = self else {
        return
      }
      switch result {
      case .success(let data):
        self.monuments = data
        let response = List.LoadData.Response(result: .success(data: self.monuments))
        self.presenter?.presentLoadData(response: response)
      case .failure(let error):
        let response = List.LoadData.Response(result: .error(error))
        self.presenter?.presentLoadData(response: response)
      }
    }
  }

  func doSelectedItem(request: List.SelectedItem.Request) {
    let item = monuments[request.index]
    AnalyticsManager.shared.trackClickMonumentItem(monumentId: item.identifier)
    let response = List.SelectedItem.Response(monumentId: item.identifier, address: item.address)
    presenter?.presentSelectedItem(response: response)
  }
}
