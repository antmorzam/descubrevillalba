//
//  HowToWorkInteractor.swift
//  descubrevillalba
//
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

protocol HowToWorkBusinessLogic {
  func doLoadStaticData(request: HowToWork.StaticData.Request)
  func doSetLanguage(request: HowToWork.SetLanguage.Request)
}

protocol HowToWorkDataStore {
  var isChangedLanguage: Bool { get set }
}

class HowToWorkInteractor: HowToWorkBusinessLogic, HowToWorkDataStore {

  // MARK: - Properties

  var presenter: HowToWorkPresentationLogic?
  var defaultsManager: UserDefaultsManager?

  var isChangedLanguage: Bool = false
  
  // MARK: - Public

  func doLoadStaticData(request: HowToWork.StaticData.Request) {
    var language: Language = .english
    let locale = defaultsManager?.language
    if locale == "es" || locale == "ca" || locale == "eu" || locale == "gl" {
      language = .spanish
    } else if locale == "fr" {
      language = .french
    } else {
      language = .english
    }

    let result = StaticDataResult(text: Localization.howItWorksInfo, language: language)
    let response = HowToWork.StaticData.Response(result: result)
    presenter?.presentStaticData(response: response)
  }
  
  func doSetLanguage(request: HowToWork.SetLanguage.Request) {
    var language = ""
    switch request.language {
    case .spanish:
      language = "es"
    case .english:
      language = "en"
    case .french:
      language = "fr"
    }
    
    isChangedLanguage = true
    defaultsManager?.language = language
    
    presenter?.presentSetLanguage(response: HowToWork.SetLanguage.Response())
  }
}
