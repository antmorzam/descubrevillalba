//
//  UIViewController.swift
//  descubrevillalba
//
//  Created by Antonio Moreno on 07/03/2022.
//

import Foundation
import UIKit

extension UIViewController {
  
  private enum UIViewControllerConstants {
    static let loaderViewTag = 7658
    static let loaderTransitionDuration: TimeInterval = 0.3
  }
  
  func openSystemSettings() {
    guard let url = URL(string: UIApplication.openSettingsURLString) else {
      return
    }
    UIApplication.shared.open(url)
  }
  
  func showLoader() {
    let loaderView = UIActivityIndicatorView()
    loaderView.color = .white
    loaderView.tag = UIViewControllerConstants.loaderViewTag
    
    let destinationView: UIView = self.view
    
    destinationView.addSubviewForAutolayout(loaderView)
    
    NSLayoutConstraint.activate([
      loaderView.centerXAnchor.constraint(equalTo: destinationView.centerXAnchor),
      loaderView.centerYAnchor.constraint(equalTo: destinationView.centerYAnchor)
    ])
    
    loaderView.startAnimating()
  }
  
  func hideLoader(_ completion: (() -> Void)? = nil) {
    let loaderView = view.viewWithTag(UIViewControllerConstants.loaderViewTag)
    loaderView?.removeFromSuperview()
    completion?()
  }
  
  func showAlertError(_ message: String?, completionRetry: (() -> Void)? = nil, completionCancel: (() -> Void)? = nil) {
    let alert = UIAlertController(title: Localization.dialogErrorTitle,
                                  message: message ?? "",
                                  preferredStyle: .alert)
    if let completionRetry = completionRetry {
      alert.addAction(UIAlertAction(title: Localization.dialogErrorButtonRetry,
                                    style: .default,
                                    handler: { _ in
                                      completionRetry()
                                    }))
    }
    alert.addAction(UIAlertAction(title: Localization.dialogErrorButtonCancel,
                                  style: .cancel,
                                  handler: { _ in
                                    completionCancel?()
                                  }))
    self.present(alert, animated: true, completion: nil)
  }
}
