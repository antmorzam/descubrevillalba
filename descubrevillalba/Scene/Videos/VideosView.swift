//
//  VideosView.swift
//  descubrevillalba
//
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

class VideosView: UIView {

  // MARK: - Constants

  private struct ViewTraits {
    // Sizes
    static let estimatedRowHeight: CGFloat = 100
  
    // Margins
    static let contentMargin: CGFloat = 18
    static let labelHMargin: CGFloat = 20
    static let labelVMargin: CGFloat = 30
    
    // Font
    static let titleFontSize: CGFloat = 32
    static let descriptionFontSize: CGFloat = 14
  }

  // MARK: - Properties

  let tableView = UITableView(frame: CGRect.zero, style: .grouped)
  let emptyLabel = UILabel()

  var emptyLabelHidden = true {
    didSet {
      emptyLabel.isHidden = emptyLabelHidden
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

  // MARK: - Private

  private func setupComponents() {
    backgroundColor = .black
    
    tableView.backgroundColor = .black
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = ViewTraits.estimatedRowHeight
    tableView.separatorStyle = .none
    tableView.allowsSelection = true
    tableView.tableFooterView = UIView(frame: .zero)
    tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

    emptyLabel.textColor = .white
    emptyLabel.textAlignment = .center
    emptyLabel.font = .dpFont(.light, ofSize: ViewTraits.descriptionFontSize)
    emptyLabel.numberOfLines = 0
    emptyLabel.text = Localization.videosEmptystateText
    emptyLabel.isHidden = true
  
    addSubviewForAutolayout(tableView)
    addSubviewForAutolayout(emptyLabel)
  }

  private func setupConstraints() {
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
      tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor,
                                         constant: ViewTraits.contentMargin),
      tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor,
                                          constant: -ViewTraits.contentMargin),
      tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
      
      emptyLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
      emptyLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor,
                                          constant: 20),
      emptyLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor,
                                          constant: -20)
    ])
  }
}
