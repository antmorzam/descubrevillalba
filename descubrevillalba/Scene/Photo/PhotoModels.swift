//
//  PhotoModels.swift
//  descubrevillalba
//
//  Copyright © 2022 Antonio Moreno. All rights reserved.
//

import Foundation

// MARK: - Use cases

enum Photo {
  enum StaticData {
    struct Request {
    }

    struct Response {
      let result: MonumentPhoto
    }

    struct ViewModel {
      let content: PhotoViewData
    }
  }
}

// MARK: - Business models

// MARK: - View models

