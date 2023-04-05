//
//  StartInteractor.swift
//  descubrevillalba
//
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

protocol StartBusinessLogic {
  func doLoadStaticData(request: Start.StaticData.Request)
  func doReloadStaticData(request: Start.StaticData.Request)
}

protocol StartDataStore {
  var isChangedLanguage: Bool { get set }
}

class StartInteractor: StartBusinessLogic, StartDataStore {

  // MARK: - Properties

  var presenter: StartPresentationLogic?

  var isChangedLanguage: Bool = false

  // MARK: - Public

  func doLoadStaticData(request: Start.StaticData.Request) {
    let response = Start.StaticData.Response()
    presenter?.presentStaticData(response: response)
  }
  
  func doReloadStaticData(request: Start.StaticData.Request) {
    if isChangedLanguage {
      let response = Start.StaticData.Response()
      presenter?.presentStaticData(response: response)
    }
  }

  // MARK: - Private
}
