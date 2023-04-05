//
//  BackBarButtonItem.swift
//  descubrepueblos
//
//  Created by Antonio Moreno on 17/08/2021.
//  Copyright © 2021 Descubre#Pueblos. All rights reserved.
//

import Foundation
import UIKit

protocol BackBarButtonItemDelegate: class {
  func backBarButtonItemDidPress(_ button: BackBarButtonItem)
}

class BackBarButtonItem: UIBarButtonItem {

  // MARK: - Constants

  struct AccesibilityIds {
    static let view = "back_button"
  }

  // MARK: - Properties

  private let barButtonView = BarButtonView()
  private let backgroundView = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0),
                                                    size: CGSize(width: 44, height: 44)))
  weak var delegate: BackBarButtonItemDelegate?
  
  var withBackground: Bool = false {
    didSet {
      showBackgroundView()
    }
  }
  
  // MARK: - View's lifecycle

  override init() {
    super.init()
    setupComponents()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Private

  private func setupComponents() {
    barButtonView.delegate = self
    barButtonView.setContentViewAccessibilityIdentifier(AccesibilityIds.view)
    barButtonView.setImage(UIImage(named: ImageIdentifiers.icnLeftArrowWhite),
                           size: 16,
                           contentMode: .center)

    backgroundView.alpha = 0.5
    backgroundView.layer.cornerRadius = 22
    backgroundView.isHidden = true
    
    barButtonView.insertSubview(backgroundView, at: 0)
    customView = barButtonView
  }

  private func showBackgroundView() {
    backgroundView.isHidden = false
  }
}

// MARK: - BarButtonViewDelegate

extension BackBarButtonItem: BarButtonViewDelegate {

  func barButtonViewDidTapContentView(_ button: BarButtonView) {
    delegate?.backBarButtonItemDidPress(self)
  }
}
