//
//  ListViewCell.swift
//  descubrevillalba
//
//  Created by Antonio Moreno on 07/03/2022.
//

import Foundation
import UIKit

struct ListViewCellData: Hashable {
  let identifier: String
  let imageUrl: String?
  let title: String
  let esPanorama: Bool
}

extension ListViewCellData {
  public static func ==(lhs: ListViewCellData, rhs: ListViewCellData) -> Bool {
    return lhs.identifier == rhs.identifier && lhs.identifier == rhs.identifier
  }

  public func hash(into hasher: inout Hasher) {
      hasher.combine(identifier)
  }
}

protocol ListViewCellDelegate: AnyObject {
  func listViewCellSelectedImage(_ view: ListViewCell)
}

class ListViewCell: UITableViewCell {

  private static let nib = UINib(nibName: "ListViewCell", bundle: nil)
  
  static func register(in table: UITableView, for identifier: String = identifier) {
    table.register(nib, forCellReuseIdentifier: identifier)
  }

  class var identifier: String {
    "ListViewCell"
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

  private let innerView = UIView()
  private let cellImageView = UIImageView()
  private let stackView = UIStackView()
  private let titleLabel = UILabel()

  private let stackView360 = UIStackView()
  private let imageView360 = UIImageView()
  private let label360 = UILabel()
  
  weak var delegate: ListViewCellDelegate?
  
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

  func setupUI(data: ListViewCellData) {
    titleLabel.text = data.title
    if data.esPanorama {
      cellImageView.image = UIImage(named: ImageIdentifiers.placeholder360)
      stackView360.isHidden = false
    } else if let imageUrl = data.imageUrl {
      cellImageView.loadStorageImage(root: "images/", name: imageUrl)
      stackView360.isHidden = true
    }
  }

  // MARK: - Private

  private func setupComponents() {
    backgroundColor = .black
    
    selectionStyle = .none
    innerView.layer.masksToBounds = true
    
    cellImageView.contentMode = .scaleAspectFill
    cellImageView.clipsToBounds = true
    
    stackView.axis = .vertical
    stackView.spacing = 0
    stackView.distribution = .fillProportionally
    stackView.alignment = .fill

    titleLabel.lineBreakMode = .byWordWrapping
    titleLabel.numberOfLines = 0
    titleLabel.textAlignment = .left
    titleLabel.textColor = .white
    titleLabel.font = .dpFont(.bold, ofSize: ViewTraits.titleFontSize)
    
    stackView.addArrangedSubview(titleLabel)

    stackView360.axis = .vertical
    stackView360.spacing = 0
    stackView360.distribution = .equalCentering
    stackView360.alignment = .center
    stackView360.isHidden = true
    
    imageView360.contentMode = .scaleAspectFit
    imageView360.image = UIImage(named: ImageIdentifiers.ic360)
    
    label360.lineBreakMode = .byWordWrapping
    label360.numberOfLines = 0
    label360.textAlignment = .center
    label360.textColor = .white
    label360.font = .dpFont(.bold, ofSize: ViewTraits.titleFontSize)
    label360.text = Localization.panoramaRowText
    
    stackView360.addArrangedSubview(imageView360)
    stackView360.addArrangedSubview(label360)
    
    innerView.addSubviewForAutolayout(cellImageView)
    innerView.addSubviewForAutolayout(stackView)
    innerView.addSubviewForAutolayout(stackView360)

    addSubviewForAutolayout(innerView)
  }

  private func setupConstraints() {
    NSLayoutConstraint.activate([
      innerView.leadingAnchor.constraint(equalTo: leadingAnchor),
      innerView.trailingAnchor.constraint(equalTo: trailingAnchor),
      innerView.topAnchor.constraint(equalTo: topAnchor),
      innerView.bottomAnchor.constraint(equalTo: bottomAnchor),

      cellImageView.heightAnchor.constraint(equalTo: cellImageView.widthAnchor,
                                            multiplier: 0.6),
      cellImageView.leadingAnchor.constraint(equalTo: innerView.leadingAnchor),
      cellImageView.trailingAnchor.constraint(equalTo: innerView.trailingAnchor),
      cellImageView.topAnchor.constraint(equalTo: innerView.topAnchor),

      stackView.leadingAnchor.constraint(equalTo: innerView.leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: innerView.trailingAnchor,
                                          constant: -ViewTraits.contentMargin),
      stackView.topAnchor.constraint(equalTo: cellImageView.bottomAnchor,
                                     constant: ViewTraits.contentSpacing),
      stackView.bottomAnchor.constraint(equalTo: innerView.bottomAnchor,
                                        constant: -ViewTraits.contentMargin),
      
      imageView360.widthAnchor.constraint(equalToConstant: 80),
      imageView360.heightAnchor.constraint(equalToConstant: 80),
      
      stackView360.leadingAnchor.constraint(equalTo: innerView.leadingAnchor,
                                            constant: ViewTraits.contentMargin),
      stackView360.trailingAnchor.constraint(equalTo: innerView.trailingAnchor,
                                             constant: -ViewTraits.contentMargin),
      stackView360.centerXAnchor.constraint(equalTo: cellImageView.centerXAnchor),
      stackView360.centerYAnchor.constraint(equalTo: cellImageView.centerYAnchor),
    ])
  }
}
