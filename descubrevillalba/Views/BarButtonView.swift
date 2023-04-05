//
//  BarButtonView.swift
//  descubrepueblos
//
//  Created by Antonio Moreno on 17/08/2021.
//  Copyright © 2021 Descubre#Pueblos. All rights reserved.
//

import Foundation
import UIKit

protocol BarButtonViewDelegate: class {
  func barButtonViewDidTapContentView(_ button: BarButtonView)
}

class BarButtonView: UIView {

  // MARK: - Constants

  private struct ViewTraits {
    // Sizes
    static let contentHeight: CGFloat = 44
    static let iconSize: CGFloat = 44

    // Fonts
    static let fontSize: CGFloat = 11
  }

  // MARK: - Properties

  weak var delegate: BarButtonViewDelegate?

  var labelOffsetX: CGFloat = 0 {
    didSet {
      labelCenterXConstraint?.constant = labelOffsetX
    }
  }

  var labelOffsetY: CGFloat = 0 {
    didSet {
      labelCenterYConstraint?.constant = labelOffsetY
    }
  }

  private let contentView = HighlightView()
  private let imageView = UIImageView()
  private let label = UILabel()

  private var labelCenterXConstraint: NSLayoutConstraint?
  private var labelCenterYConstraint: NSLayoutConstraint?

  // MARK: - View's lifecycle

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupComponents()
    setupConstraints()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Actions

  @objc private func didTapContentView() {
    delegate?.barButtonViewDidTapContentView(self)
  }

  // MARK: - Public

  func setContentViewAccessibilityIdentifier(_ identifier: String) {
    contentView.isAccessibilityElement = true
    contentView.accessibilityIdentifier = identifier
  }

  func setImage(_ image: UIImage?,
                size: CGFloat = ViewTraits.iconSize,
                contentMode: UIView.ContentMode = .scaleAspectFit) {
    imageView.contentMode = contentMode
    imageView.image = image?.resizeTo(size: size)
  }

  func setText(_ text: String, animated: Bool = false) {
    guard animated else {
      label.text = text
      return
    }
    UIView.animateKeyframes(withDuration: 0.6, delay: 0, options: .calculationModeLinear, animations: {
      UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.2, animations: {
        self.contentView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
      })
      UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.4, animations: {
        self.contentView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        self.label.text = text
      })
      UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.4, animations: {
        self.contentView.transform = .identity
      })
    })
  }

  // MARK: - Private

  private func setupComponents() {
    clipsToBounds = false

    contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapContentView)))

    imageView.contentMode = .scaleAspectFit

    label.numberOfLines = 1
    label.textAlignment = .center
    label.textColor = .black

    contentView.addSubviewForAutolayout(imageView)
    contentView.addSubviewForAutolayout(label)

    addSubviewForAutolayout(contentView)
  }

  private func setupConstraints() {
    let labelCenterXConstraint = label.centerXAnchor.constraint(equalTo: imageView.centerXAnchor,
                                                                constant: labelOffsetX)
    self.labelCenterXConstraint = labelCenterXConstraint

    let labelCenterYConstraint = label.centerYAnchor.constraint(equalTo: imageView.centerYAnchor,
                                                                constant: labelOffsetY)
    self.labelCenterYConstraint = labelCenterYConstraint

    NSLayoutConstraint.activate([
      contentView.heightAnchor.constraint(equalToConstant: ViewTraits.contentHeight),
      contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
      contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
      contentView.topAnchor.constraint(equalTo: topAnchor),
      contentView.bottomAnchor.constraint(equalTo: bottomAnchor),

      imageView.widthAnchor.constraint(equalToConstant: ViewTraits.iconSize),
      imageView.heightAnchor.constraint(equalToConstant: ViewTraits.iconSize),
      imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      imageView.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor),

      labelCenterXConstraint,
      labelCenterYConstraint
    ])
  }
}
