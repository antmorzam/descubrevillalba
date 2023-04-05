//
//  PlayerView.swift
//  descubrevillalba
//
//  Created by Antonio Moreno on 12/03/2022.
//

import Foundation
import UIKit

struct PlayerViewData {
  let imageUrl: String
  let title: String
  let root: String
}

class PlayerView: UIView {

  // MARK: - Properties

  private let mainImageView = UIImageView()
  
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

  func setupUI(data: PlayerViewData) {
    if !data.imageUrl.isEmpty {
      mainImageView.loadStorageImage(root: data.root, name: data.imageUrl)
    }
  }

  // MARK: - Private

  func setupComponents() {
    backgroundColor = .black
    
    mainImageView.contentMode = .scaleAspectFill
    mainImageView.layer.shadowColor = UIColor.black.cgColor
    mainImageView.layer.shadowOpacity = 1
    mainImageView.layer.shadowOffset = CGSize.zero
  
    addSubviewForAutolayout(mainImageView)
  }

  private func setupConstraints() {
    NSLayoutConstraint.activate([
      mainImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
      mainImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
      mainImageView.topAnchor.constraint(equalTo: topAnchor),
      mainImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
    ])
  }
}
