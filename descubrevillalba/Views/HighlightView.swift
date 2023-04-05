//
//  Highlight.swift
//  descubrepueblos
//
//  Created by Antonio Moreno on 17/08/2021.
//  Copyright © 2021 Descubre#Pueblos. All rights reserved.
//

import Foundation
import UIKit

class HighlightView: UIView {

  // MARK: - Constants

  private struct ViewTraits {
    // Animation
    static let animationDuration: TimeInterval = 0.16
  }

  // MARK: - Lifecycle

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    animateToHighlight()
  }

  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesMoved(touches, with: event)
    if let touch = touches.first, hitTest(touch.location(in: self), with: event) != nil {
      animateToHighlight()
    } else {
      animateToNormal()
    }
  }

  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesEnded(touches, with: event)
    animateToNormal()
  }

  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesCancelled(touches, with: event)
    animateToNormal()
  }

  // MARK: - Private

  private func animateToHighlight() {
    UIView.animate(withDuration: ViewTraits.animationDuration, delay: 0, options: .curveLinear, animations: {
      self.alpha = 0.25
    })
  }

  private func animateToNormal() {
    UIView.animate(withDuration: ViewTraits.animationDuration, delay: 0, options: .curveLinear, animations: {
      self.alpha = 1
    })
  }
}
