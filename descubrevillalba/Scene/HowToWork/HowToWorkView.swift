//
//  HowToWorkView.swift
//  descubrevillalba
//
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol HowToWorkViewDelegate {
  func howToWorkViewLanguageDidTap(_ view: HowToWorkView, language: Language)
}

class HowToWorkView: UIView {

  // MARK: - Constants

  private struct ViewTraits {
    // Sizes
    static let barHeight: CGFloat = 44

    // Margins
    static let labelVMargin: CGFloat = 30
    static let labelHMargin: CGFloat = 20
    
    // Font
    static let titleFontSize: CGFloat = 18
    static let descriptionFontSize: CGFloat = 14
  }

  // MARK: - Properties

  private let scrollView = UIScrollView()
  private let mainImageView = UIImageView()
  private let shadowView = UIView()
  private let howWorkTitleLabel = UILabel()
  private let howWorkInfoLabel = UILabel()
  private let selectTitleLabel = UILabel()
  private let languagesStackView = UIStackView()
  private let spainImageView = UIImageView()
  private let englandImageView = UIImageView()
  private let franceImageView = UIImageView()
  private let logosView = UIView()
  private let logoImageView = UIImageView()
  private let oficialInfoLabel = UILabel()
  private let spainView = LanguageView()
  private let englishView = LanguageView()
  private let franceView = LanguageView()
  
  var delegate: HowToWorkViewDelegate?

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

  // MARK: - Public

  func setupUI(data: String, language: Language) {
    howWorkInfoLabel.text = data
    switch language {
    case .spanish:
      spainView.isSelected = true
    case .english:
      englishView.isSelected = true
    case .french:
      franceView.isSelected = true
    }
  }

  // MARK: - Private

  private func setupComponents() {
    backgroundColor = .black

    mainImageView.contentMode = .scaleAspectFill
    mainImageView.clipsToBounds = true
    mainImageView.image = UIImage(named: ImageIdentifiers.convento)
    
    shadowView.frame = CGRect(x: 0, y: 0, width: ScreenSize.width, height: 130)
    
    let gradient = CAGradientLayer()
    gradient.frame = shadowView.bounds
    gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]

    shadowView.layer.insertSublayer(gradient, at: 0)

    howWorkTitleLabel.textColor = .white
    howWorkTitleLabel.textAlignment = .center
    howWorkTitleLabel.font = .dpFont(.regular, ofSize: ViewTraits.titleFontSize)
    howWorkTitleLabel.numberOfLines = 0
    howWorkTitleLabel.text = Localization.howItWorksHeader
    
    howWorkInfoLabel.textColor = .white
    howWorkInfoLabel.textAlignment = .left
    howWorkInfoLabel.font = .dpFont(.light, ofSize: ViewTraits.descriptionFontSize)
    howWorkInfoLabel.numberOfLines = 0

    selectTitleLabel.textColor = .white
    selectTitleLabel.textAlignment = .center
    selectTitleLabel.font = .dpFont(.regular, ofSize: ViewTraits.titleFontSize)
    selectTitleLabel.numberOfLines = 0
    selectTitleLabel.text = Localization.howItWorksLanguage

    languagesStackView.alignment = .center
    languagesStackView.distribution = .fillEqually
    languagesStackView.axis = .horizontal
    languagesStackView.spacing = 20
    
    spainView.iconImage = UIImage(named: ImageIdentifiers.spain) ?? UIImage()
    spainView.language = .spanish
    spainView.delegate = self
    englishView.iconImage = UIImage(named: ImageIdentifiers.english) ?? UIImage()
    englishView.language = .english
    englishView.delegate = self
    franceView.iconImage = UIImage(named: ImageIdentifiers.francia) ?? UIImage()
    franceView.language = .french
    franceView.delegate = self
    
    languagesStackView.addArrangedSubview(spainView)
    languagesStackView.addArrangedSubview(englishView)
    languagesStackView.addArrangedSubview(franceView)
    
    logoImageView.image = UIImage(named: ImageIdentifiers.juntaLogo)
    
    oficialInfoLabel.textColor = .white
    oficialInfoLabel.textAlignment = .center
    oficialInfoLabel.font = .dpFont(.regular, ofSize: 8)
    oficialInfoLabel.numberOfLines = 0
    oficialInfoLabel.text = Localization.howItWorksMunitic
    
    scrollView.addSubviewForAutolayout(mainImageView)
    scrollView.addSubviewForAutolayout(shadowView)
    scrollView.addSubviewForAutolayout(howWorkTitleLabel)
    scrollView.addSubviewForAutolayout(howWorkInfoLabel)
    scrollView.addSubviewForAutolayout(selectTitleLabel)
    scrollView.addSubviewForAutolayout(languagesStackView)
    logosView.addSubviewForAutolayout(logoImageView)
    logosView.addSubviewForAutolayout(oficialInfoLabel)
    scrollView.addSubviewForAutolayout(logosView)

    addSubviewForAutolayout(scrollView)
  }

  private func setupConstraints() {
    var height: CGFloat = ViewTraits.barHeight
    if #available(iOS 13.0, *) {
      height += UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
    } else {
      height += UIApplication.shared.statusBarFrame.height
    }
    
    NSLayoutConstraint.activate([
      scrollView.topAnchor.constraint(equalTo: topAnchor, constant: -height),
      scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
      scrollView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
      scrollView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
      
      mainImageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
      mainImageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
      mainImageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
      mainImageView.widthAnchor.constraint(equalToConstant: ScreenSize.width),
      mainImageView.heightAnchor.constraint(equalToConstant: ScreenSize.height * 0.4),
      
      shadowView.bottomAnchor.constraint(equalTo: mainImageView.bottomAnchor),
      shadowView.leadingAnchor.constraint(equalTo: mainImageView.leadingAnchor),
      shadowView.trailingAnchor.constraint(equalTo: mainImageView.trailingAnchor),
      shadowView.heightAnchor.constraint(equalToConstant: 130.0),
      
      howWorkTitleLabel.topAnchor.constraint(equalTo: shadowView.bottomAnchor,
                                             constant: ViewTraits.labelVMargin),
      howWorkTitleLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor,
                                                 constant: ViewTraits.labelHMargin),
      howWorkTitleLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor,
                                                  constant: -ViewTraits.labelHMargin),
      
      howWorkInfoLabel.topAnchor.constraint(equalTo: howWorkTitleLabel.bottomAnchor,
                                            constant: ViewTraits.labelVMargin),
      howWorkInfoLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor,
                                                constant: ViewTraits.labelHMargin),
      howWorkInfoLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor,
                                                 constant: -ViewTraits.labelHMargin),
      
      selectTitleLabel.topAnchor.constraint(equalTo: howWorkInfoLabel.bottomAnchor,
                                            constant: ViewTraits.labelVMargin),
      selectTitleLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor,
                                                constant: ViewTraits.labelHMargin),
      selectTitleLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor,
                                                 constant: -ViewTraits.labelHMargin),
      
      languagesStackView.topAnchor.constraint(equalTo: selectTitleLabel.bottomAnchor,
                                              constant: ViewTraits.labelVMargin),
      languagesStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor,
                                                  constant: ViewTraits.labelHMargin),
      languagesStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor,
                                                   constant: -ViewTraits.labelHMargin),
      
      logosView.topAnchor.constraint(equalTo: languagesStackView.bottomAnchor,
                                     constant: ViewTraits.labelVMargin),
      logosView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor,
                                         constant: ViewTraits.labelHMargin),
      logosView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor,
                                          constant: -ViewTraits.labelHMargin),
      logosView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor,
                                        constant: -ViewTraits.labelVMargin),
      
      logoImageView.heightAnchor.constraint(equalToConstant: 100),
      logoImageView.widthAnchor.constraint(equalToConstant: 100),
      logoImageView.leadingAnchor.constraint(equalTo: logosView.leadingAnchor,
                                             constant: ViewTraits.labelVMargin),
      logoImageView.trailingAnchor.constraint(equalTo: oficialInfoLabel.leadingAnchor,
                                              constant: -ViewTraits.labelVMargin),
      logoImageView.centerYAnchor.constraint(equalTo: oficialInfoLabel.centerYAnchor),
      
      oficialInfoLabel.trailingAnchor.constraint(equalTo: logosView.trailingAnchor,
                                                 constant: -ViewTraits.labelVMargin),
      oficialInfoLabel.topAnchor.constraint(equalTo: logosView.topAnchor,
                                            constant: ViewTraits.labelVMargin),
      oficialInfoLabel.bottomAnchor.constraint(equalTo: logosView.bottomAnchor,
                                               constant: -ViewTraits.labelVMargin)
    ])
  }
}

extension HowToWorkView: LanguageViewDelegate {
  
  func languageViewDidTap(_ view: LanguageView, language: Language) {
    delegate?.howToWorkViewLanguageDidTap(self, language: language)
  }
}
