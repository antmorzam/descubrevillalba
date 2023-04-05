//
//  PhotoViewController.swift
//  descubrevillalba
//
//  Copyright © 2022 Antonio Moreno. All rights reserved.
//

import UIKit
import CTPanoramaView

struct PhotoViewData {
  let esPanorama: Bool
  let url: String?
}

protocol PhotoDisplayLogic: AnyObject {
  func displayStaticData(viewModel: Photo.StaticData.ViewModel)
}

class PhotoViewController: UIViewController, UIScrollViewDelegate, PhotoDisplayLogic {
  
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var panoramaView: CTPanoramaView!
  
  var imageUrl: String? {
    didSet {
      if let imageUrl = imageUrl {
        imageView.loadStorageImage(root: "images/", name: imageUrl)
      }
    }
  }

  var interactor: PhotoBusinessLogic?
  var router: (PhotoRoutingLogic & PhotoDataPassing)?

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
    let interactor = PhotoInteractor()
    let presenter = PhotoPresenter()
    let router = PhotoRouter()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
  }

  // MARK: - View's lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.largeTitleDisplayMode = .never
    setupNavigationBar()
    setupComponents()
    interactor?.doLoadStaticData(request: Photo.StaticData.Request())
    
    AnalyticsManager.shared.trackScreenView(Screen.GALLERY_DETAILS)
  }
  
  func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    return imageView
  }
  
  // MARK: - Private

  private func setupNavigationBar() {
    let backButton = BackBarButtonItem()
    backButton.delegate = self
    navigationItem.leftBarButtonItem = backButton
  }
  
  private func setupComponents() {
    view.backgroundColor = .black
    
    scrollView.delegate = self
    scrollView.minimumZoomScale = 1.0
    scrollView.maximumZoomScale = 5.0
    imageView.contentMode = .scaleAspectFit
    
    panoramaView.controlMethod = .both
  }
  
  func displayStaticData(viewModel: Photo.StaticData.ViewModel) {
    if viewModel.content.esPanorama, let imageUrl = viewModel.content.url {
      scrollView.isHidden = true
      panoramaView.loadStorageImage(root: "/", name: imageUrl)
    } else if let imageUrl = viewModel.content.url {
      panoramaView.isHidden = true
      imageView.loadStorageImage(root: "images/", name: imageUrl)
    }
  }
  
  public func scrollViewDidZoom(_ scrollView: UIScrollView) {
    if scrollView.zoomScale > 1 {
      if let image = imageView.image {
        let ratioW = imageView.frame.width / image.size.width
        let ratioH = imageView.frame.height / image.size.height
        
        let ratio = ratioW < ratioH ? ratioW : ratioH
        let newWidth = image.size.width * ratio
        let newHeight = image.size.height * ratio
        
        let conditionLeft = newWidth * scrollView.zoomScale > imageView.frame.width
        let left = 0.5 * (conditionLeft ? newWidth - imageView.frame.width :
                          (scrollView.frame.width - scrollView.contentSize.width))
        let conditionTop = newHeight*scrollView.zoomScale > imageView.frame.height
        let top = 0.5 * (conditionTop ? newHeight - imageView.frame.height :
                          (scrollView.frame.height - scrollView.contentSize.height))
        
        scrollView.contentInset = UIEdgeInsets(top: top, left: left, bottom: top, right: left)
        
      }
    } else {
      scrollView.contentInset = .zero
    }
  }
}

// MARK: - BackBarButtonItemDelegate

extension PhotoViewController: BackBarButtonItemDelegate {

  func backBarButtonItemDidPress(_ button: BackBarButtonItem) {
    router?.routeBack()
  }
}
