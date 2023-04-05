//
//  GalleryModels.swift
//  descubrevillalba
//
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

// MARK: - Use cases

enum Gallery {
  enum LoadData {
    struct Request {
    }

    struct Response {
      let result: GalleryResponseResult
    }

    struct ViewModel {
      let content: GalleryViewModelContent
    }
  }
  
  enum SelectedPhoto {
    struct Request {
      let index: Int
    }

    struct Response {
    }

    struct ViewModel {
    }
  }
}

// MARK: - Business models

enum GalleryResponseResult {
  case loading
  case error(_ error: Error)
  case success(data: [MonumentPhoto])
}

// MARK: - View models

enum GalleryViewModelContent {
  case loading
  case error(message: String?)
  case success(data: [ListViewCellData])
}

// MARK: - View models

struct GalleryViewData: Hashable {
  let imageUrl: String?
  let title: String
}

extension GalleryViewData {
  public static func ==(lhs: GalleryViewData, rhs: GalleryViewData) -> Bool {
    return lhs.imageUrl == rhs.imageUrl && lhs.imageUrl == rhs.imageUrl
  }

  public func hash(into hasher: inout Hasher) {
      hasher.combine(imageUrl)
  }
}

enum GallerySection {
  case images
}
