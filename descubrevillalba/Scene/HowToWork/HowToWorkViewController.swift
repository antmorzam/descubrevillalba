//
//  HowToWorkViewController.swift
//  descubrevillalba
//
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol HowToWorkDisplayLogic: class {
  func displayStaticData(viewModel: HowToWork.StaticData.ViewModel)
  func displaySetLanguage(viewModel: HowToWork.SetLanguage.ViewModel)
}

class HowToWorkViewController: UIViewController {

  // MARK: - Properties

  var interactor: HowToWorkBusinessLogic?
  var router: (HowToWorkRoutingLogic & HowToWorkDataPassing)?

  private let sceneView = HowToWorkView()

  // MARK: - Object's lifecycle

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setup()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }

  // MARK: - Setup

  private func setup() {
    let viewController = self
    let interactor = HowToWorkInteractor()
    let presenter = HowToWorkPresenter()
    let router = HowToWorkRouter()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    interactor.defaultsManager = UserDefaultsManager.shared
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
  }

  // MARK: - View's lifecycle

  override func loadView() {
    view = sceneView
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupNavigationBar()
    doLoadStaticData()
    sceneView.delegate = self

    AnalyticsManager.shared.trackScreenView(Screen.HOW_IT_WORKS)
  }

  // MARK: - Private

  private func setupNavigationBar() {
    let backButton = BackBarButtonItem()
    backButton.delegate = self
    navigationItem.leftBarButtonItem = backButton
  }
  
  private func setLanguage(_ data: Language) {
    let request = HowToWork.SetLanguage.Request(language: data)
    interactor?.doSetLanguage(request: request)
  }
  
  private func showAlert(language: Language) {
    let alertVC = UIAlertController(title: Localization.howItWorksLanguage, message: Localization.dialogSelectlanguageText, preferredStyle: .alert)
    let cancel = UIAlertAction(title: Localization.dialogErrorButtonCancel, style: .cancel, handler: nil)
    let confirm = UIAlertAction(title: Localization.dialogSelectlanguagePositive, style: .default) { _ in
      self.setLanguage(language)
    }
    alertVC.addAction(cancel)
    alertVC.addAction(confirm)
    present(alertVC, animated: true, completion: nil)
  }
}

// MARK: - Output

extension HowToWorkViewController {

  private func doLoadStaticData() {
    let request = HowToWork.StaticData.Request()
    interactor?.doLoadStaticData(request: request)
  }
}

// MARK: - Input

extension HowToWorkViewController: HowToWorkDisplayLogic {

  func displayStaticData(viewModel: HowToWork.StaticData.ViewModel) {
    sceneView.setupUI(data: viewModel.content.text, language: viewModel.content.language)
  }
  
  func displaySetLanguage(viewModel: HowToWork.SetLanguage.ViewModel) {
    router?.routeBack()
  }
}

// MARK: - BackBarButtonItemDelegate

extension HowToWorkViewController: BackBarButtonItemDelegate {

  func backBarButtonItemDidPress(_ button: BackBarButtonItem) {
    router?.routeBack()
  }
}

// MARK: - HowToWorkViewDelegate

extension HowToWorkViewController: HowToWorkViewDelegate {

  func howToWorkViewLanguageDidTap(_ view: HowToWorkView, language: Language) {
    showAlert(language: language)
  }
}
