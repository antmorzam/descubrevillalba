//
//  HowToWorkModels.swift
//  descubrevillalba
//
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

// MARK: - Use cases

enum HowToWork {
  enum StaticData {
    struct Request {
    }

    struct Response {
      let result: StaticDataResult
      
    }

    struct ViewModel {
      let content: StaticDataContent
    }
  }
  
  enum SetLanguage {
    struct Request {
      let language: Language
    }
    struct Response {
    }

    struct ViewModel {
    }
  }
}

// MARK: - Business models

struct StaticDataResult {
  let text: String
  let language: Language
}

// MARK: - View models

struct StaticDataContent {
  let text: String
  let language: Language
}
