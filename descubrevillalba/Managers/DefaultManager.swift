//
//  DefaultManager.swift
//  descubrevillalba
//
//  Created by Antonio Moreno on 23/04/2022.
//

import Foundation

private enum DefaultsKeys {
  static let language = "language"
}

protocol DefaultsManager: AnyObject {
  var language: String { get set }
}

class UserDefaultsManager {

  class var shared: UserDefaultsManager {
      struct Static {
          static let instance = UserDefaultsManager()
      }
      
      return Static.instance
  }
    
  private let userDefaults = UserDefaults.standard
}

extension UserDefaultsManager: DefaultsManager {

  // MARK: - Properties
  
  var language: String {
    get {
      userDefaults.object(forKey: DefaultsKeys.language) as? String ?? NSLocale.current.languageCode ?? ""
    }

    set {
      userDefaults.set(newValue, forKey: DefaultsKeys.language)
    }
  }
}
