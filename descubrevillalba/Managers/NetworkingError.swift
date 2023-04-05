//
//  NetworkingError.swift
//  descubrevillalba
//
//  Created by Antonio Moreno on 13/03/2022.
//

import Foundation

public enum NetworkingError: String, Error {
  case unknown = "unknownError"
}

extension NetworkingError: LocalizedError {
  
  public var errorDescription: String? {
    switch self {
    case .unknown:
      return Localization.dialogErrorMessage
    }
  }
}
