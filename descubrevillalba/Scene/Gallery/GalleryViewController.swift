//
//  GalleryViewController.swift
//  descubrevillalba
//
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol GalleryDisplayLogic: AnyObject {
  func displayLoadData(viewModel: Gallery.LoadData.ViewModel)
  func displaySelectedPhoto(response: Gallery.SelectedPhoto.ViewModel)
}

class GalleryViewController: UIViewController {

  // MARK: - Properties

  var interactor: GalleryBusinessLogic?
  var router: (GalleryRoutingLogic & GalleryDataPassing)?

  private var datasource: UITableViewDiffableDataSource<GallerySection, AnyHashable>?
  private let sceneView = GalleryView()

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
    let interactor = GalleryInteractor()
    let presenter = GalleryPresenter()
    let router = GalleryRouter()
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
    
    AnalyticsManager.shared.trackScreenView(Screen.GALLERY)
  }

  // MARK: - Private

  private func setupNavigationBar() {
    title = Localization.galleryToolbarText
    
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
    sceneView.tableView.register(ListViewCell.self,
                                 forCellReuseIdentifier: ListViewCell.reuseIdentifier)
    sceneView.tableView.delegate = self

    datasource = UITableViewDiffableDataSource(tableView: sceneView.tableView, cellProvider: { (tableView, indexPath, data) -> UITableViewCell? in
      guard let cell = tableView.dequeueReusableCell(withIdentifier: ListViewCell.identifier, for: indexPath) as? ListViewCell,
            let data = data as? ListViewCellData else {
        return UITableViewCell(style: .default, reuseIdentifier: "cell")
      }
      cell.setupUI(data: data)
      return cell
    })
  }
  
  private func updateDataSource(_ data: [ListViewCellData]) {
    var snapshot = NSDiffableDataSourceSnapshot<GallerySection, AnyHashable>()
    snapshot.appendSections([.images])
    snapshot.appendItems(data, toSection: .images)
    DispatchQueue.main.async { [weak self] in
      self?.datasource?.apply(snapshot, animatingDifferences: false)
    }
  }
}

// MARK: - Output

extension GalleryViewController {
  
  private func doLoadData() {
    let request = Gallery.LoadData.Request()
    interactor?.doLoadData(request: request)
  }
  
  private func doSelectedPhoto(index: Int) {
    let request = Gallery.SelectedPhoto.Request(index: index)
    interactor?.doSelectedPhoto(request: request)
  }
}

// MARK: - Input

extension GalleryViewController: GalleryDisplayLogic {

  func displayLoadData(viewModel: Gallery.LoadData.ViewModel) {
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
  
  func displaySelectedPhoto(response: Gallery.SelectedPhoto.ViewModel) {
    router?.navigateToPhoto()
  }
}

// MARK: - UITableViewDelegate

extension GalleryViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    doSelectedPhoto(index: indexPath.row)
  }
}

// MARK: - BackBarButtonItemDelegate

extension GalleryViewController: BackBarButtonItemDelegate {

  func backBarButtonItemDidPress(_ button: BackBarButtonItem) {
    router?.routeBack()
  }
}
