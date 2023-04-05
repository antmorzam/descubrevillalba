//
//  StartPresenter.swift
//  descubrevillalba
//
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

protocol StartPresentationLogic {
  func presentStaticData(response: Start.StaticData.Response)
}

class StartPresenter: StartPresentationLogic {

  // MARK: - Properties

  weak var viewController: StartDisplayLogic?

  // MARK: - Public

  func presentStaticData(response: Start.StaticData.Response) {
    let viewModel = Start.StaticData.ViewModel(points: Localization.mainMonumentsButton, scan: Localization.mainScannerButton)
    viewController?.displayStaticData(viewModel: viewModel)
  }

  // MARK: - Private
}
