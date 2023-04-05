//
//  ListViewController.swift
//  descubrevillalba
//
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import CoreLocation

protocol ListDisplayLogic: class {
  func displayLoadData(viewModel: List.LoadData.ViewModel)
  func displaySelectedItem(response: List.SelectedItem.ViewModel)
}

class ListViewController: UIViewController {

  // MARK: - Properties

  var interactor: ListBusinessLogic?
  var router: (ListRoutingLogic & ListDataPassing)?

  private var datasource: UITableViewDiffableDataSource<ListSection, AnyHashable>?
  private let sceneView = ListView()

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
    let interactor = ListInteractor()
    let presenter = ListPresenter()
    let router = ListRouter()
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
    
    AnalyticsManager.shared.trackScreenView(Screen.MONUMENT_LIST)
  }

  // MARK: - Private

  private func setupNavigationBar() {
    title = Localization.monumentListToolbarText
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
    var snapshot = NSDiffableDataSourceSnapshot<ListSection, AnyHashable>()
    snapshot.appendSections([.images])
    snapshot.appendItems(data, toSection: .images)
    DispatchQueue.main.async { [weak self] in
      self?.datasource?.apply(snapshot, animatingDifferences: false)
    }
  }
  
  private func coordinates(forAddress address: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
    let geocoder = CLGeocoder()
    geocoder.geocodeAddressString(address) {
      (placemarks, error) in
      guard error == nil else {
        self.showAlertError(Localization.mapNotAddress)
        completion(nil)
        return
      }
      completion(placemarks?.first?.location?.coordinate)
    }
  }
}

// MARK: - Output

extension ListViewController {

  private func doLoadData() {
    let request = List.LoadData.Request()
    interactor?.doLoadData(request: request)
  }
  
  private func doSelectedItem(index: Int) {
    let request = List.SelectedItem.Request(index: index)
    interactor?.doSelectedItem(request: request)
  }
}

// MARK: - Input

extension ListViewController: ListDisplayLogic {

  func displayLoadData(viewModel: List.LoadData.ViewModel) {
    switch viewModel.content {
    case .loading:
      showLoader()
    case .success(let data):
      hideLoader()
      updateDataSource(data)
    case .error(let message):
      hideLoader()
      self.showAlertError(message, completionRetry: {
        self.doLoadData()
      }, completionCancel: {
        self.router?.routeBack()
      })
    }
  }
  
  func displaySelectedItem(response: List.SelectedItem.ViewModel) {
    if response.monumentId == Monument.dv03ermita.rawValue {
      let query = "?saddr=&daddr==\(CLLocationDegrees(37.394359)),\(CLLocationDegrees(-6.491255))"
      let path = "http://maps.apple.com/" + query
      if let url = URL(string: path) {
        UIApplication.shared.open(url)
      }
    } else {
      coordinates(forAddress: response.address) { location in
        guard let location = location else {
          self.showAlertError(Localization.mapNotAddress)
          return
        }
        let query = "?saddr=&daddr==\(location.latitude),\(location.longitude)"
        let path = "http://maps.apple.com/" + query
        if let url = URL(string: path) {
          UIApplication.shared.open(url)
        }
      }
    }
  }
}

// MARK: - UITableViewDelegate

extension ListViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    doSelectedItem(index: indexPath.row)
  }
}

// MARK: - BackBarButtonItemDelegate

extension ListViewController: BackBarButtonItemDelegate {

  func backBarButtonItemDidPress(_ button: BackBarButtonItem) {
    router?.routeBack()
  }
}
