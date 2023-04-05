//
//  ScannerViewController.swift
//  descubrevillalba
//
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import AVFoundation
import Lottie

protocol ScannerDisplayLogic: AnyObject {
  func displayLoadDetail(viewModel: Scanner.LoadDetail.ViewModel)
}

class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
  
  // MARK: - Properties
  
  var interactor: ScannerBusinessLogic?
  var router: (ScannerRoutingLogic & ScannerDataPassing)?
  
  @IBOutlet private weak var videoView: UIView!
  @IBOutlet private weak var lottieView: AnimationView!
  @IBOutlet private weak var flashButton: UIButton!
  @IBOutlet private weak var permissionView: UIView!
  @IBOutlet private weak var permissionLabel: UILabel!
  @IBOutlet private weak var permissionButton: UIButton!
  
  var captureSession = AVCaptureSession()
  var previewLayer: AVCaptureVideoPreviewLayer?
  var qrCodeFrameView: UIView?
  
  private let bottomSpace: CGFloat = 80.0
  private let spaceFactor: CGFloat = 16.0
  
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
    let interactor = ScannerInteractor()
    let presenter = ScannerPresenter()
    let router = ScannerRouter()
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
    setupNavigationBar()
    setupComponents()
    setupScanner()
    
    AnalyticsManager.shared.trackScreenView(Screen.SCANNER)
  }
  
  @IBAction func flashDidTap(_ sender: UIButton) {
    toggleTorch()
  }
  
  @IBAction func goToPermission() {
    openSystemSettings()
  }
  
  func toggleTorch() {
    guard let device = AVCaptureDevice.default(for: .video) else { return }
    
    if device.hasTorch {
      do {
        try device.lockForConfiguration()
        device.torchMode = device.torchMode == .on ? .off : .on
        device.unlockForConfiguration()
      } catch {
        showAlertError(Localization.dialogErrorMessage)
      }
    } else {
      flashButton.isHidden = true
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    lottieView.play()
    if !captureSession.isRunning {
      captureSession.startRunning()
    }
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    lottieView.stop()
    if captureSession.isRunning {
      captureSession.stopRunning()
    }
  }
  
  // MARK: - Private
  
  private func setupNavigationBar() {
    if #available(iOS 13.0, *), let navigationBar = navigationController?.navigationBar {
      let appearance = UINavigationBarAppearance()
      appearance.configureWithTransparentBackground()
      navigationBar.standardAppearance = appearance
    }
    
    navigationController?.setNavigationBarHidden(false, animated: true)
    let backButton = BackBarButtonItem()
    backButton.delegate = self
    navigationItem.leftBarButtonItem = backButton
  }
  
  private func setupComponents() {
    lottieView.loopMode = .loop
    lottieView.animationSpeed = 0.5
    lottieView.contentMode = .scaleAspectFit
    lottieView.play()
    
    permissionLabel.text = Localization.scannerPermissionsText
    permissionButton.setTitle(Localization.scannerPermissionsButton, for: .normal)
  }
  
  private func setupScanner() {
    let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInTrueDepthCamera, .builtInDualCamera, .builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back)
    
    guard let captureDevice = deviceDiscoverySession.devices.first else {
      print("Failed to get the camera device")
      return
    }
    
    do {
      if let inputs = captureSession.inputs as? [AVCaptureDeviceInput] {
        for input in inputs {
          captureSession.removeInput(input)
        }
      }
      
      // Get an instance of the AVCaptureDeviceInput class using the previous device object.
      let input = try AVCaptureDeviceInput(device: captureDevice)
  
      // Set the input device on the capture session.
      if captureSession.inputs.isEmpty {
        self.captureSession.addInput(input)
      }
      
      // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
      let captureMetadataOutput = AVCaptureMetadataOutput()
      // Set delegate and use the default dispatch queue to execute the call back
      
      if captureSession.outputs.isEmpty {
        captureSession.addOutput(captureMetadataOutput)
      }
      
      captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
      captureMetadataOutput.metadataObjectTypes = [.qr]
      
      // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
      previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
      previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
      previewLayer?.frame = view.layer.bounds
      view.layer.addSublayer(previewLayer!)
      view.bringSubviewToFront(flashButton)
      view.bringSubviewToFront(lottieView)
      //      createCornerFrame()
      // Start video capture.
      captureSession.startRunning()
    } catch {
      // If any error occurs, simply print it out and don't continue any more.
      if AVCaptureDevice.authorizationStatus(for: .video) != .authorized {
        lottieView.isHidden = true
        flashButton.isHidden = true
        permissionView.isHidden = false
      }
      return
    }
  }

  func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
    captureSession.stopRunning()
    // Check if the metadataObjects array is not nil and it contains at least one object.
    if metadataObjects.count == 0 {
      qrCodeFrameView?.frame = CGRect.zero
      return
    }
    
    // Get the metadata object.
    let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
    
    if metadataObj.type == AVMetadataObject.ObjectType.qr {
      // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
      let barCodeObject = previewLayer?.transformedMetadataObject(for: metadataObj)
      qrCodeFrameView?.frame = barCodeObject!.bounds
      
      if metadataObj.stringValue != nil {
        doLoadDetail(item: metadataObj.stringValue)
      }
    }
  }
}

// MARK: - Output

extension ScannerViewController {
  
  private func doLoadDetail(item: String?) {
    let request = Scanner.LoadDetail.Request(item: item)
    interactor?.doLoadDetail(request: request)
  }
}

// MARK: - Input

extension ScannerViewController: ScannerDisplayLogic {
  
  func displayLoadDetail(viewModel: Scanner.LoadDetail.ViewModel) {
    router?.routeToDetail()
  }
}

// MARK: - BackBarButtonItemDelegate

extension ScannerViewController: BackBarButtonItemDelegate {
  
  func backBarButtonItemDidPress(_ button: BackBarButtonItem) {
    router?.routeBack()
  }
}
