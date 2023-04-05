//
//  LanguageView.swift
//  descubrevillalba
//
//  Created by Antonio Moreno on 22/04/2022.
//

import Foundation
import UIKit

protocol LanguageViewDelegate: AnyObject {
  func languageViewDidTap(_ view: LanguageView, language: Language)
}

class LanguageView: UIView {

  // MARK: - Constants

  private struct ViewTraits {
    // Sizes
    static let iconSize: CGFloat = 50
    static let checkSize: CGFloat = 21
    static let cornerRadius: CGFloat = 25
  }

  // MARK: - Properties

  weak var delegate: LanguageViewDelegate?

  private let contentView = UIView()
  private let iconImageView = UIImageView()
  private let checkImageView = UIImageView()
  private let selectView = UIView()

  var language: Language = .spanish
  var iconImage: UIImage = UIImage() {
    didSet {
      iconImageView.image = iconImage
    }
  }
  
  var isSelected: Bool = false {
    didSet {
      checkImageView.isHidden = isSelected ? false : true
      selectView.isHidden = isSelected ? false : true
    }
  }

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
    delegate?.languageViewDidTap(self, language: language)
  }

  // MARK: - Public

  func setupUI(data: UIImage) {
    iconImageView.image = data
  }

  // MARK: - Private

  private func setupComponents() {
    clipsToBounds = false

    self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapContentView)))
    
    iconImageView.contentMode = .scaleAspectFit
    iconImageView.layer.cornerRadius = ViewTraits.cornerRadius
    iconImageView.layer.borderWidth = 1
    iconImageView.layer.borderColor = UIColor.white.cgColor

    checkImageView.contentMode = .scaleAspectFit
    checkImageView.isHidden = true
    checkImageView.image = UIImage(named: ImageIdentifiers.check)
    
    selectView.backgroundColor = UIColor.black
    selectView.alpha = 0.4
    selectView.layer.cornerRadius = ViewTraits.cornerRadius
    selectView.isHidden = true
    
    contentView.addSubviewForAutolayout(iconImageView)
    contentView.addSubviewForAutolayout(selectView)
    contentView.addSubviewForAutolayout(checkImageView)
    
    addSubviewForAutolayout(contentView)
  }

  private func setupConstraints() {
    NSLayoutConstraint.activate([
      contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
      contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
      contentView.topAnchor.constraint(equalTo: topAnchor),
      contentView.bottomAnchor.constraint(equalTo: bottomAnchor),

      iconImageView.heightAnchor.constraint(equalToConstant: ViewTraits.iconSize),
      iconImageView.widthAnchor.constraint(equalToConstant: ViewTraits.iconSize),
      iconImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
      iconImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

      checkImageView.heightAnchor.constraint(equalToConstant: ViewTraits.checkSize),
      checkImageView.widthAnchor.constraint(equalToConstant: ViewTraits.checkSize),
      checkImageView.centerXAnchor.constraint(equalTo: iconImageView.centerXAnchor),
      checkImageView.centerYAnchor.constraint(equalTo: iconImageView.centerYAnchor),

      selectView.leadingAnchor.constraint(equalTo: leadingAnchor),
      selectView.trailingAnchor.constraint(equalTo: trailingAnchor),
      selectView.topAnchor.constraint(equalTo: topAnchor),
      selectView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
  }
}
