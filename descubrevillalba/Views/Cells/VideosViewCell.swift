//
//  VideosViewCell.swift
//  descubrevillalba
//
//  Created by Antonio Moreno on 08/03/2022.
//

import Foundation
import UIKit
//import FirebaseUI

class VideosViewCell: UITableViewCell {

  class var identifier: String {
    "VideosViewCell"
  }
  
  static var reuseIdentifier: String {
    String(describing: Self.self)
  }

  // MARK: - Constants

  private struct ViewTraits {
    // Margins
    static let contentMargin: CGFloat = 18

    // Spacings
    static let contentSpacing: CGFloat = 6

    // Fonts
    static let titleFontSize: CGFloat = 16
  }

  // MARK: - Properties

  private let cellImageView = UIImageView()
  private let titleLabel = UILabel()
  
  // MARK: - Lifecycle

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupComponents()
    setupConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Public

  func setupUI(data: VideosViewData) {
    cellImageView.image = UIImage(named: ImageIdentifiers.youtubeIcon)
    titleLabel.text = data.title
  }

  // MARK: - Private

  private func setupComponents() {
    backgroundColor = .black
    
    selectionStyle = .none

    cellImageView.contentMode = .scaleAspectFit

    titleLabel.lineBreakMode = .byWordWrapping
    titleLabel.numberOfLines = 0
    titleLabel.textAlignment = .left
    titleLabel.textColor = .white
    titleLabel.font = .dpFont(.bold, ofSize: ViewTraits.titleFontSize)

    addSubviewForAutolayout(cellImageView)
    addSubviewForAutolayout(titleLabel)
  }

  private func setupConstraints() {
    NSLayoutConstraint.activate([
      cellImageView.heightAnchor.constraint(equalToConstant: 50),
      cellImageView.widthAnchor.constraint(equalToConstant: 50),
      cellImageView.topAnchor.constraint(equalTo: topAnchor),
      cellImageView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                             constant: ViewTraits.contentMargin),
      cellImageView.trailingAnchor.constraint(equalTo: titleLabel.leadingAnchor,
                                              constant: -ViewTraits.contentMargin),
      cellImageView.bottomAnchor.constraint(equalTo: bottomAnchor,
                                            constant: -ViewTraits.contentMargin),
      
      titleLabel.centerYAnchor.constraint(equalTo: cellImageView.centerYAnchor),
      titleLabel.trailingAnchor.constraint(greaterThanOrEqualTo: trailingAnchor,
                                           constant: -ViewTraits.contentMargin)
    ])
  }
}
