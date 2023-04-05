//
//  DetailViewController.swift
//  descubrevillalba
//
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import AVKit

protocol DetailDisplayLogic: class {
  func displayLoadData(viewModel: Detail.LoadData.ViewModel)
  func displayAudioSelected(viewModel: Detail.AudioSelected.ViewModel)
}

class DetailViewController: UIViewController {

  // MARK: - Properties

  var interactor: DetailBusinessLogic?
  var router: (DetailRoutingLogic & DetailDataPassing)?

  private let sceneView = DetailView()

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
    let interactor = DetailInteractor()
    let presenter = DetailPresenter()
    let router = DetailRouter()
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
    doLoadData()
    sceneView.delegate = self
  }

  // MARK: - Private

  private func setupNavigationBar() {
    let backButton = BackBarButtonItem()
    backButton.delegate = self
    navigationItem.leftBarButtonItem = backButton
  }
}

// MARK: - Output

extension DetailViewController {

  private func doLoadData() {
    let request = Detail.LoadData.Request()
    interactor?.doLoadData(request: request)
  }
  
  private func doAudioSelected() {
    let request = Detail.AudioSelected.Request()
    interactor?.doAudioSelected(request: request)
  }
  
  private func doTrackClickVideo() {
    let request = Detail.TrackClickVideo.Request()
    interactor?.doTrackClickVideo(request: request)
  }
}

// MARK: - Input

extension DetailViewController: DetailDisplayLogic {

  func displayLoadData(viewModel: Detail.LoadData.ViewModel) {
    switch viewModel.content {
    case .loading:
      showLoader()
    case .success(let data):
      hideLoader()
      sceneView.setupUI(data: data)
    case .error(let message):
      hideLoader()
      self.showAlertError(message, completionRetry: {
        self.doLoadData()
      }, completionCancel: {
        self.router?.routeBack()
      })
    case .invalidCode:
      AnalyticsManager.shared.trackScreenView(Screen.SCAN_INVALID)
      sceneView.invalidCodeHide = false
    }
  }
  
  func displayAudioSelected(viewModel: Detail.AudioSelected.ViewModel) {
    switch viewModel.content {
    case .loading:
      showLoader()
      self.view.isUserInteractionEnabled = false
    case .success(let data):
      self.view.isUserInteractionEnabled = true
      hideLoader()
      loadPlayer(audioUrl: data.audioUrl, imageUrl: data.imageUrl, root: data.root)
    case .error(let message):
      self.view.isUserInteractionEnabled = true
      hideLoader()
      self.showAlertError(message, completionRetry: {
        self.doAudioSelected()
      })
    }
  }
  
  private func loadPlayer(audioUrl: URL, imageUrl: String, root: String) {
    let avAssest = AVAsset(url: audioUrl)
    let playerItem = AVPlayerItem(asset: avAssest)
    let audioPlayer = AVPlayer(playerItem: playerItem)

    let playerViewController = AVPlayerViewController()
    playerViewController.player = audioPlayer
    playerViewController.exitsFullScreenWhenPlaybackEnds = true
    let playerView = PlayerView(frame: CGRect(x: 0,
                                              y: 0,
                                              width: ScreenSize.width,
                                              height: ScreenSize.height))
    playerView.setupUI(data: PlayerViewData(imageUrl: imageUrl,
                                            title: "",
                                            root: root))
    playerViewController.contentOverlayView?.addSubview(playerView)
    
    self.present(playerViewController, animated: true, completion: {
      AnalyticsManager.shared.trackScreenView(Screen.AUDIOGUIDE)
      audioPlayer.play()
    })
  }
}

// MARK: - BackBarButtonItemDelegate

extension DetailViewController: BackBarButtonItemDelegate {

  func backBarButtonItemDidPress(_ button: BackBarButtonItem) {
    router?.routeBack()
  }
}

extension DetailViewController: DetailViewDelegate {

  func detailViewGalleryDidTap(_ view: DetailView) {
    router?.routeToGallery()
  }
  
  func detailViewVideosDidTap(_ view: DetailView) {
    doTrackClickVideo()
    router?.routeToVideos()
  }
  
  func detailViewAudioDidTap(_ view: DetailView) {
    doAudioSelected()
  }
}
