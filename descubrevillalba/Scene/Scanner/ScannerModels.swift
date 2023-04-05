//
//  ScannerModels.swift
//  descubrevillalba
//
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

// MARK: - Use cases

enum Scanner {
  enum StaticData {
    struct Request {
    }

    struct Response {
    }

    struct ViewModel {
    }
  }
  
  enum LoadDetail {
    struct Request {
      let item: String?
    }

    struct Response {
    }

    struct ViewModel {
    }
  }
}

// MARK: - Business models

// MARK: - View models

struct ScannerViewData {
//  let text: String
}
