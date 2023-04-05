//
//  ScannerPresenter.swift
//  descubrevillalba
//
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

protocol ScannerPresentationLogic {
  func presentLoadDetail(response: Scanner.LoadDetail.Response)
}

class ScannerPresenter: ScannerPresentationLogic {

  // MARK: - Properties

  weak var viewController: ScannerDisplayLogic?

  // MARK: - Public

  func presentLoadDetail(response: Scanner.LoadDetail.Response) {
    let viewModel = Scanner.LoadDetail.ViewModel()
    viewController?.displayLoadDetail(viewModel: viewModel)
  }
}
