//
//  StartViewController.swift
//  descubrevillalba
//
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import AVFoundation

protocol StartDisplayLogic: class {
  func displayStaticData(viewModel: Start.StaticData.ViewModel)
}

class StartViewController: UIViewController {

  // MARK: - Properties

  var interactor: StartBusinessLogic?
  var router: (StartRoutingLogic & StartDataPassing)?

  private let sceneView = StartView()

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
    let interactor = StartInteractor()
    let presenter = StartPresenter()
    let router = StartRouter()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
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
    AnalyticsManager.shared.trackScreenView(Screen.MAIN)
    AVCaptureDevice.requestAccess(for: .video) { _ in }
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    doReloadStaticData()
  }

  // MARK: - Private

  private func setupNavigationBar() {
    if #available(iOS 13.0, *), let navigationBar = navigationController?.navigationBar {
      let appearance = UINavigationBarAppearance()
      appearance.configureWithTransparentBackground()
      appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
      navigationBar.standardAppearance = appearance
    }
    
    navigationController?.setNavigationBarHidden(false, animated: true)
    
    let infoButton = UIBarButtonItem(image: UIImage(named: ImageIdentifiers.infoIcon), style: .plain, target: self, action: #selector(infoDidTap))
    infoButton.tintColor = .white
    navigationItem.rightBarButtonItem = infoButton
  }
  
  // MARK: - Private
  
  @objc func infoDidTap() {
    router?.navigateToHowToWork()
  }
}

// MARK: - Output

extension StartViewController {

  private func doLoadStaticData() {
    let request = Start.StaticData.Request()
    interactor?.doLoadStaticData(request: request)
  }
  
  private func doReloadStaticData() {
    let request = Start.StaticData.Request()
    interactor?.doReloadStaticData(request: request)
  }
}

// MARK: - Input

extension StartViewController: StartDisplayLogic {

  func displayStaticData(viewModel: Start.StaticData.ViewModel) {
    sceneView.setupUI(points: viewModel.points, scan: viewModel.scan)
  }
}

// MARK: - StartViewDelegate

extension StartViewController: StartViewDelegate {
  
  func startViewListDidTap(_ view: StartView) {
    router?.navigateToList()
  }
  
  func startViewQrDidTap(_ view: StartView) {
    router?.navigateToQr()
  }
}
