//
//  VideosModels.swift
//  descubrevillalba
//
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

// MARK: - Use cases

enum Videos {
  enum LoadData {
    struct Request {
    }

    struct Response {
      let result: VideosResponseResult
    }

    struct ViewModel {
      let content: VideosViewModelContent
    }
  }
  
  enum SelectedItem {
    struct Request {
      let index: Int
    }

    struct Response {
      let video: MonumentVideo
    }

    struct ViewModel {
      let video: MonumentVideo
    }
  }
}

// MARK: - Business models

enum VideosResponseResult {
  case loading
  case error(_ error: Error)
  case success(data: [MonumentVideo])
}

// MARK: - View models

enum VideosViewModelContent {
  case loading
  case error(message: String?)
  case success(data: [VideosViewData])
}

// MARK: - View models

struct VideosViewData: Hashable {
  let identifier: Int
  let title: String
}

extension VideosViewData {
  public static func ==(lhs: VideosViewData, rhs: VideosViewData) -> Bool {
    return lhs.identifier == rhs.identifier && lhs.identifier == rhs.identifier
  }

  public func hash(into hasher: inout Hasher) {
      hasher.combine(identifier)
  }
}

enum VideosSection {
  case videos
}
