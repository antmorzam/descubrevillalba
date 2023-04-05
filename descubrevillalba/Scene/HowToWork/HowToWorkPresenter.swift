//
//  HowToWorkPresenter.swift
//  descubrevillalba
//
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

protocol HowToWorkPresentationLogic {
  func presentStaticData(response: HowToWork.StaticData.Response)
  func presentSetLanguage(response: HowToWork.SetLanguage.Response)
}

class HowToWorkPresenter: HowToWorkPresentationLogic {

  // MARK: - Properties

  weak var viewController: HowToWorkDisplayLogic?

  // MARK: - Public

  func presentStaticData(response: HowToWork.StaticData.Response) {
    let content = StaticDataContent(text: response.result.text, language: response.result.language)
    let viewModel = HowToWork.StaticData.ViewModel(content: content)
    viewController?.displayStaticData(viewModel: viewModel)
  }
  
  func presentSetLanguage(response: HowToWork.SetLanguage.Response) {
    let viewModel = HowToWork.SetLanguage.ViewModel()
    viewController?.displaySetLanguage(viewModel: viewModel)
  }

  // MARK: - Private
}
