//
//  VideosViewController.swift
//  descubrevillalba
//
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol VideosDisplayLogic: class {
  func displayLoadData(viewModel: Videos.LoadData.ViewModel)
  func displaySelectedItem(viewModel: Videos.SelectedItem.ViewModel)
}

class VideosViewController: UIViewController {

  // MARK: - Properties

  var interactor: VideosBusinessLogic?
  var router: (VideosRoutingLogic & VideosDataPassing)?

  private var datasource: UITableViewDiffableDataSource<VideosSection, AnyHashable>?
  private let sceneView = VideosView()

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
    let interactor = VideosInteractor()
    let presenter = VideosPresenter()
    let router = VideosRouter()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    interactor.monumentAPI = MonumentAPI()
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
    setupComponents()
    doLoadData()
    
    AnalyticsManager.shared.trackScreenView(Screen.VIDEOS)
  }

  // MARK: - Private

  private func setupNavigationBar() {
    title = Localization.videosToolbarText
    
    if #available(iOS 13.0, *), let navigationBar = navigationController?.navigationBar {
      let appearance = UINavigationBarAppearance()
      appearance.configureWithTransparentBackground()
      appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
      navigationBar.standardAppearance = appearance
    }
    
    let backButton = BackBarButtonItem()
    backButton.delegate = self
    navigationItem.leftBarButtonItem = backButton
  }
  
  private func setupComponents() {
    sceneView.tableView.register(VideosViewCell.self,
                                 forCellReuseIdentifier: VideosViewCell.reuseIdentifier)
    sceneView.tableView.delegate = self

    datasource = UITableViewDiffableDataSource(tableView: sceneView.tableView, cellProvider: { (tableView, indexPath, data) -> UITableViewCell? in
      guard let cell = tableView.dequeueReusableCell(withIdentifier: VideosViewCell.identifier, for: indexPath) as? VideosViewCell,
            let data = data as? VideosViewData else {
        return UITableViewCell(style: .default, reuseIdentifier: "cell")
      }
      cell.setupUI(data: data)
      return cell
    })
  }
  
  private func updateDataSource(_ data: [VideosViewData]) {
    var snapshot = NSDiffableDataSourceSnapshot<VideosSection, AnyHashable>()
    snapshot.appendSections([.videos])
    snapshot.appendItems(data, toSection: .videos)
    DispatchQueue.main.async { [weak self] in
      self?.datasource?.apply(snapshot, animatingDifferences: false)
    }
  }
  
  private func playInYoutube(youtubeUrl: String) {
    if let youtubeURL = URL(string: youtubeUrl) {
      UIApplication.shared.open(youtubeURL, options: [:], completionHandler: nil)
    }
  }
}

// MARK: - Output

extension VideosViewController {
  
  private func doLoadData() {
    let request = Videos.LoadData.Request()
    interactor?.doLoadData(request: request)
  }
  
  private func doSelectedItem(index: Int) {
    let request = Videos.SelectedItem.Request(index: index)
    interactor?.doSelectedItem(request: request)
  }
}

// MARK: - Input

extension VideosViewController: VideosDisplayLogic {

  func displayLoadData(viewModel: Videos.LoadData.ViewModel) {
    switch viewModel.content {
    case .loading:
      showLoader()
    case .success(let data):
      hideLoader()
      updateDataSource(data)
      sceneView.emptyLabelHidden = !data.isEmpty
    case .error(let message):
      hideLoader()
      self.showAlertError(message, completionRetry: {
        self.doLoadData()
      }, completionCancel: {
        self.router?.routeBack()
      })
    }
  }
  
  func displaySelectedItem(viewModel: Videos.SelectedItem.ViewModel) {
    playInYoutube(youtubeUrl: viewModel.video.videoUrl)
  }
}

// MARK: - UITableViewDelegate

extension VideosViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    doSelectedItem(index: indexPath.row)
  }
}

// MARK: - BackBarButtonItemDelegate

extension VideosViewController: BackBarButtonItemDelegate {

  func backBarButtonItemDidPress(_ button: BackBarButtonItem) {
    router?.routeBack()
  }
}
