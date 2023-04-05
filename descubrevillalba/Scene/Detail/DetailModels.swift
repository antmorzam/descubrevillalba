//
//  DetailModels.swift
//  descubrevillalba
//
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

// MARK: - Use cases

enum Detail {
  enum LoadData {
    struct Request {
    }

    struct Response {
      let result: InfoLugarResult
    }

    struct ViewModel {
      let content: InfoLugarContent
    }
  }
  
  enum AudioSelected {
    struct Request {
    }
    
    struct Response {
      let result: AudioSelectedResult
    }
    
    struct ViewModel {
      let content: AudioSelectedContent
    }
  }
  
  enum TrackClickVideo {
    struct Request {
    }
    
    struct Response {
    }
    
    struct ViewModel {
    }
  }
}

// MARK: - Business models

enum InfoLugarResult {
  case loading
  case error(_ error: Error)
  case success(data: MonumentDetails)
  case invalidCode
}

enum AudioSelectedResult {
  case loading
  case error(_ error: Error)
  case success(data: AudioItem)
}

// MARK: - View models

enum InfoLugarContent {
  case loading
  case error(_ error: String)
  case success(data: DetailViewData)
  case invalidCode
}

enum AudioSelectedContent {
  case loading
  case error(_ error: String)
  case success(data: AudioItem)
}

struct DetailViewData {
  let imageUrl: String
  let title: String
  let description: String
}

struct AudioItem {
  let audioUrl: URL
  let imageUrl: String
  let root: String
}
