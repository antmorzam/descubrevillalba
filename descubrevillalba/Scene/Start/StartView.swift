//
//  StartView.swift
//  descubrevillalba
//
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol StartViewDelegate: AnyObject {
  func startViewQrDidTap(_ view: StartView)
  func startViewListDidTap(_ view: StartView)
}

class StartView: UIView {

  // MARK: - Constants

  private struct ViewTraits {
    // Sizes
    static let buttonWidth: CGFloat = 20
    static let buttonHeight: CGFloat = 70

    // Margins
    static let labelVMargin: CGFloat = 20
    static let buttonHMargin: CGFloat = 20
  }

  // MARK: - Properties

  private let backgroundImageView = UIImageView()
  private let layerView = UIView()
  private let logoImageView = UIImageView()
  private let nameImageView = UIImageView()
  private let listButton = UIButton()
  private let qrButton = UIButton()

  weak var delegate: StartViewDelegate?

  // MARK: - Lifecycle

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupComponents()
    setupConstraints()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Actions

  @objc func listDidTap() {
    delegate?.startViewListDidTap(self)
  }
  
  @objc func qrDidTap() {
    delegate?.startViewQrDidTap(self)
  }

  func setupUI(points: String, scan: String) {
    listButton.setTitle(points, for: .normal)
    qrButton.setTitle(scan, for: .normal)
  }

  // MARK: - Private

  private func setupComponents() {
    layerView.backgroundColor = .black
    layerView.alpha = 0.3

    backgroundImageView.image = UIImage(named: ImageIdentifiers.iglesia)
    logoImageView.image = UIImage(named: ImageIdentifiers.escudoBlanco)
    nameImageView.image = UIImage(named: ImageIdentifiers.nameLogo)
    
    backgroundImageView.contentMode = .scaleAspectFill
    logoImageView.contentMode = .scaleAspectFit
    nameImageView.contentMode = .scaleAspectFit
    
    listButton.backgroundColor = .clear
    listButton.setTitleColor(.white, for: .normal)
    listButton.addTarget(self, action: #selector(listDidTap), for: .touchUpInside)
    
    qrButton.backgroundColor = UIColor.white.withAlphaComponent(0.3)
    qrButton.layer.cornerRadius = 13
    qrButton.setTitleColor(.white, for: .normal)
    qrButton.addTarget(self, action: #selector(qrDidTap), for: .touchUpInside)
    
    addSubviewForAutolayout(backgroundImageView)
    addSubviewForAutolayout(layerView)
    addSubviewForAutolayout(logoImageView)
    addSubviewForAutolayout(nameImageView)
    addSubviewForAutolayout(qrButton)
    addSubviewForAutolayout(listButton)
  }

  private func setupConstraints() {
    NSLayoutConstraint.activate([
      backgroundImageView.topAnchor.constraint(equalTo: topAnchor),
      backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
      backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
      backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
      layerView.topAnchor.constraint(equalTo: topAnchor),
      layerView.leadingAnchor.constraint(equalTo: leadingAnchor),
      layerView.trailingAnchor.constraint(equalTo: trailingAnchor),
      layerView.bottomAnchor.constraint(equalTo: bottomAnchor),
      logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
      logoImageView.widthAnchor.constraint(equalToConstant: 50),
      logoImageView.heightAnchor.constraint(equalToConstant: 90),
      logoImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor,
                                         constant: 30),
      nameImageView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor,
                                         constant: -15),
      nameImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
      nameImageView.widthAnchor.constraint(equalTo: widthAnchor, constant: -40),
      nameImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.2746),
      
      listButton.leadingAnchor.constraint(equalTo: leadingAnchor,
                                          constant: ViewTraits.buttonHMargin),
      listButton.trailingAnchor.constraint(equalTo: trailingAnchor,
                                       constant: -ViewTraits.buttonHMargin),
      listButton.heightAnchor.constraint(equalToConstant: ViewTraits.buttonHeight),
      
      qrButton.topAnchor.constraint(equalTo: listButton.bottomAnchor),
      qrButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor,
                                       constant: -ViewTraits.buttonHMargin),
      qrButton.leadingAnchor.constraint(equalTo: leadingAnchor,
                                       constant: ViewTraits.buttonHMargin),
      qrButton.trailingAnchor.constraint(equalTo: trailingAnchor,
                                       constant: -ViewTraits.buttonHMargin),
      qrButton.heightAnchor.constraint(equalToConstant: ViewTraits.buttonHeight)
    ])
  }
}
