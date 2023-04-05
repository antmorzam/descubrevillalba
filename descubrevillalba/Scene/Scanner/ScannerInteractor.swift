//
//  ScannerInteractor.swift
//  descubrevillalba
//
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

protocol ScannerBusinessLogic {
  func doLoadDetail(request: Scanner.LoadDetail.Request)
}

protocol ScannerDataStore {
  var monumentId: String? { get set }
}

class ScannerInteractor: ScannerBusinessLogic, ScannerDataStore {

  // MARK: - Properties

  var presenter: ScannerPresentationLogic?
  var monumentId: String?
  
  // MARK: - Public
  
  func doLoadDetail(request: Scanner.LoadDetail.Request) {
    guard let item = request.item else {
      return
    }
    
    let validCode = checkItem(item)
    monumentId = validCode ? item : nil
    let response = Scanner.LoadDetail.Response()
    presenter?.presentLoadDetail(response: response)
  }
  
  private func checkItem(_ item: String) -> Bool {
    switch item {
    case "dv01-castillo", "dv02-convento", "dv03-ermita", "dv04-cap-trini", "dv05-cap-cerri", "dv06-cap-real", "dv07-cap-niche", "dv08-cap-paterna", "dv09-cs-lizcano", "dv10-cs-banco", "dv11-cs-botica", "dv12-cs-romero", "dv13-cs-espina", "dv14-bod-landa", "dv15-bod-diezm", "dv16-tor-alam", "dv17-tor-molino", "dv18-hospital", "dv19-ayunta", "dv20-nazareno", "dv21-rocio", "dv22-carmen":
      return true
    default:
      return false
    }
  }
}
