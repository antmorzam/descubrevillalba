//
//  ListView.swift
//  descubrevillalba
//
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

class ListView: UIView {

  // MARK: - Constants

  private struct ViewTraits {
    // Sizes
    static let estimatedRowHeight: CGFloat = 250
  
    // Margins
    static let contentMargin: CGFloat = 18
    static let labelHMargin: CGFloat = 20
    static let labelVMargin: CGFloat = 30
    
    // Font
    static let titleFontSize: CGFloat = 32
  }

  // MARK: - Properties

  let tableView = UITableView(frame: CGRect.zero, style: .grouped)

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

    addSubviewForAutolayout(tableView)
  }

  private func setupConstraints() {
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
      tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor,
                                         constant: ViewTraits.contentMargin),
      tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor,
                                          constant: -ViewTraits.contentMargin),
      tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
  }
}
