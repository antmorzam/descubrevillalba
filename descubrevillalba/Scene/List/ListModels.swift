//
//  ListModels.swift
//  descubrevillalba
//
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

// MARK: - Use cases

enum List {
  enum StaticData {
    struct Request {
    }

    struct Response {
    }

    struct ViewModel {
    }
  }
  
  enum LoadData {
    struct Request {
    }

    struct Response {
      let result: ListResponseResult
    }

    struct ViewModel {
      let content: ListViewModelContent
    }
  }
  
  enum SelectedItem {
    struct Request {
      let index: Int
    }

    struct Response {
      let monumentId: String
      let address: String
    }

    struct ViewModel {
      let monumentId: String
      let address: String
    }
  }
}

// MARK: - Business models

enum ListResponseResult {
  case loading
  case error(_ error: Error)
  case success(data: [MonumentDetails])
}

// MARK: - View models

enum ListViewModelContent {
  case loading
  case error(message: String?)
  case success(data: [ListViewCellData])
}

// MARK: - View models

enum ListSection {
  case images
}
