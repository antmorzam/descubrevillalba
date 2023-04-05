//
//  DetailView.swift
//  descubrevillalba
//
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol DetailViewDelegate: AnyObject {
  func detailViewGalleryDidTap(_ view: DetailView)
  func detailViewVideosDidTap(_ view: DetailView)
  func detailViewAudioDidTap(_ view: DetailView)
}

class DetailView: UIView {

  // MARK: - Constants

  private struct ViewTraits {
    // Sizes
    static let barHeight: CGFloat = 44
    static let iconSize: CGFloat = 60
    static let cornerRadius: CGFloat = 30
    
    // Margins
    static let labelVMargin: CGFloat = 30
    static let labelHMargin: CGFloat = 20
    static let buttonVMargin: CGFloat = 18
    static let buttonMargin: CGFloat = 40
    
    // Font
    static let titleFontSize: CGFloat = 32
    static let descriptionFontSize: CGFloat = 14
  }

  // MARK: - Properties

  private let scrollView = UIScrollView()
  private let titleLabel = UILabel()
  private let timeLabel = UILabel()
  private let languageImageView = UIImageView()
  private let playImageContentView = UIView()
  private let playImageView = UIImageView()
  private let descriptionLabel = UILabel()
  private let mainImageView = UIImageView()
  private let shadowView = UIView()
  private let galleryButton = UIButton()
  private let videoButton = UIButton()
  private let audioButton = UIButton()
  private let invalidCodeView = UIView()
  private let invalidCodeTitleLabel = UILabel()
  private let invalidCodeSubtitleLabel = UILabel()
  private let invalidCodeImageView = UIImageView()

  weak var delegate: DetailViewDelegate?

  var invalidCodeHide: Bool = true {
    didSet {
      invalidCodeView.isHidden = invalidCodeHide
    }
  }

  // MARK: - Lifecycle

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupComponents()
    setupConstraints()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Public

  func setupUI(data: DetailViewData) {
    if !data.imageUrl.isEmpty {
      mainImageView.loadStorageImage(root: "images/", name: data.imageUrl)
    }
    titleLabel.text = data.title
    descriptionLabel.text = data.description
    galleryButton.isHidden = false
    audioButton.isHidden = false
    videoButton.isHidden = false
  }

  // MARK: - Private

  private func setupComponents() {
    backgroundColor = .black

    mainImageView.contentMode = .scaleAspectFill
    mainImageView.clipsToBounds = true
  
    shadowView.frame = CGRect(x: 0, y: 0, width: ScreenSize.width, height: 130.0)
    
    let gradient = CAGradientLayer()
    gradient.frame = shadowView.bounds
    gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]

    shadowView.layer.insertSublayer(gradient, at: 0)
    
    titleLabel.textColor = .white
    titleLabel.textAlignment = .center
    titleLabel.font = .dpFont(.light, ofSize: ViewTraits.titleFontSize)
    titleLabel.numberOfLines = 0
    
    descriptionLabel.textColor = .white
    descriptionLabel.textAlignment = .left
    descriptionLabel.font = .dpFont(.light, ofSize: ViewTraits.descriptionFontSize)
    descriptionLabel.numberOfLines = 0

    galleryButton.setImage(UIImage(named: ImageIdentifiers.galleryIcon), for: .normal)
    galleryButton.imageEdgeInsets = UIEdgeInsets(top: 20,left: 18,bottom: 20,right: 18)
    setButton(galleryButton)
    galleryButton.addTarget(self, action: #selector(galleryDidTap), for: .touchUpInside)
    galleryButton.isHidden = true
    
    videoButton.setImage(UIImage(named: ImageIdentifiers.videoIcon), for: .normal)
    videoButton.imageEdgeInsets = UIEdgeInsets(top: 18,left: 18,bottom: 18,right: 18)
    setButton(videoButton)
    videoButton.addTarget(self, action: #selector(videosDidTap), for: .touchUpInside)
    videoButton.isHidden = true
    
    audioButton.setImage(UIImage(named: ImageIdentifiers.audioguiaIcon), for: .normal)
    audioButton.imageEdgeInsets = UIEdgeInsets(top: 18,left: 15,bottom: 18,right: 15)
    setButton(audioButton)
    audioButton.addTarget(self, action: #selector(audioDidTap), for: .touchUpInside)
    audioButton.isHidden = true
    
    invalidCodeView.isHidden = true
    
    invalidCodeTitleLabel.text = Localization.scannerInvalidQrcodeTitle
    invalidCodeTitleLabel.textColor = .white
    invalidCodeTitleLabel.textAlignment = .center
    invalidCodeTitleLabel.font = .dpFont(.bold, ofSize: ViewTraits.descriptionFontSize)
    invalidCodeTitleLabel.numberOfLines = 0
    
    invalidCodeSubtitleLabel.text = Localization.scannerInvalidQrcodeInfo
    invalidCodeSubtitleLabel.textColor = .white
    invalidCodeSubtitleLabel.textAlignment = .center
    invalidCodeSubtitleLabel.font = .dpFont(.light, ofSize: ViewTraits.descriptionFontSize)
    invalidCodeSubtitleLabel.numberOfLines = 0
    
    invalidCodeImageView.image = UIImage(named: ImageIdentifiers.invalidCode)
    invalidCodeImageView.contentMode = .scaleAspectFit
    
    scrollView.addSubviewForAutolayout(mainImageView)
    scrollView.addSubviewForAutolayout(shadowView)
    scrollView.addSubviewForAutolayout(titleLabel)
    scrollView.addSubviewForAutolayout(timeLabel)
    scrollView.addSubviewForAutolayout(languageImageView)
    scrollView.addSubviewForAutolayout(playImageContentView)
    scrollView.addSubviewForAutolayout(descriptionLabel)
    scrollView.addSubviewForAutolayout(galleryButton)
    scrollView.addSubviewForAutolayout(videoButton)
    scrollView.addSubviewForAutolayout(audioButton)
    
    invalidCodeView.addSubviewForAutolayout(invalidCodeTitleLabel)
    invalidCodeView.addSubviewForAutolayout(invalidCodeImageView)
    invalidCodeView.addSubviewForAutolayout(invalidCodeSubtitleLabel)
    
    addSubviewForAutolayout(scrollView)
    addSubviewForAutolayout(invalidCodeView)
  }

  @objc func galleryDidTap() {
    delegate?.detailViewGalleryDidTap(self)
  }
  
  @objc func videosDidTap() {
    delegate?.detailViewVideosDidTap(self)
  }
  
  @objc func audioDidTap() {
    delegate?.detailViewAudioDidTap(self)
  }

  private func setButton(_ button: UIButton) {
    button.layer.cornerRadius = ViewTraits.cornerRadius
    button.layer.borderWidth = 1
    button.layer.borderColor = UIColor.white.cgColor
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
      mainImageView.heightAnchor.constraint(equalToConstant: ScreenSize.height * 0.7),
      
      shadowView.bottomAnchor.constraint(equalTo: mainImageView.bottomAnchor),
      shadowView.leadingAnchor.constraint(equalTo: mainImageView.leadingAnchor),
      shadowView.trailingAnchor.constraint(equalTo: mainImageView.trailingAnchor),
      shadowView.heightAnchor.constraint(equalToConstant: 130.0),
      
      galleryButton.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -ViewTraits.buttonVMargin),
      galleryButton.trailingAnchor.constraint(equalTo: videoButton.leadingAnchor, constant: -ViewTraits.buttonMargin),
      galleryButton.heightAnchor.constraint(equalToConstant: ViewTraits.iconSize),
      galleryButton.widthAnchor.constraint(equalToConstant: ViewTraits.iconSize),
      
      videoButton.centerYAnchor.constraint(equalTo: galleryButton.centerYAnchor),
      videoButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
      videoButton.heightAnchor.constraint(equalToConstant: ViewTraits.iconSize),
      videoButton.widthAnchor.constraint(equalToConstant: ViewTraits.iconSize),
      
      audioButton.centerYAnchor.constraint(equalTo: galleryButton.centerYAnchor),
      audioButton.leadingAnchor.constraint(equalTo: videoButton.trailingAnchor, constant: ViewTraits.buttonMargin),
      audioButton.heightAnchor.constraint(equalToConstant: ViewTraits.iconSize),
      audioButton.widthAnchor.constraint(equalToConstant: ViewTraits.iconSize),

      titleLabel.centerYAnchor.constraint(equalTo: mainImageView.bottomAnchor),
      titleLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: ViewTraits.labelHMargin),
      titleLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -ViewTraits.labelHMargin),
      
      descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,
                                            constant: ViewTraits.labelVMargin),
      descriptionLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor,
                                                constant: ViewTraits.labelHMargin),
      descriptionLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor,
                                                constant: -ViewTraits.labelHMargin),
      descriptionLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor,
                                                constant: -ViewTraits.labelVMargin),
      
      invalidCodeView.topAnchor.constraint(equalTo: topAnchor),
      invalidCodeView.bottomAnchor.constraint(equalTo: bottomAnchor),
      invalidCodeView.leadingAnchor.constraint(equalTo: leadingAnchor),
      invalidCodeView.trailingAnchor.constraint(equalTo: trailingAnchor),
      
      invalidCodeTitleLabel.leadingAnchor.constraint(equalTo: invalidCodeView.leadingAnchor,
                                                     constant: ViewTraits.labelHMargin),
      invalidCodeTitleLabel.trailingAnchor.constraint(equalTo: invalidCodeView.trailingAnchor,
                                                     constant: -ViewTraits.labelHMargin),
      invalidCodeTitleLabel.bottomAnchor.constraint(equalTo: invalidCodeImageView.topAnchor,
                                                     constant: -ViewTraits.labelVMargin),
      
      invalidCodeImageView.centerYAnchor.constraint(equalTo: invalidCodeView.centerYAnchor),
      invalidCodeImageView.centerXAnchor.constraint(equalTo: invalidCodeView.centerXAnchor),
      invalidCodeImageView.widthAnchor.constraint(equalToConstant: 240),
      invalidCodeImageView.heightAnchor.constraint(equalToConstant: 240),
      
      invalidCodeSubtitleLabel.topAnchor.constraint(equalTo: invalidCodeImageView.bottomAnchor,
                                                    constant: ViewTraits.labelHMargin),
      invalidCodeSubtitleLabel.leadingAnchor.constraint(equalTo: invalidCodeView.leadingAnchor,
                                                        constant: ViewTraits.labelHMargin),
      invalidCodeSubtitleLabel.trailingAnchor.constraint(equalTo: invalidCodeView.trailingAnchor,
                                                         constant: -ViewTraits.labelHMargin)
    ])
  }
}
