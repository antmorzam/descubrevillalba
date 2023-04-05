//
//  VideosInteractor.swift
//  descubrevillalba
//
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

protocol VideosBusinessLogic {
  func doLoadData(request: Videos.LoadData.Request)
  func doSelectedItem(request: Videos.SelectedItem.Request)
}

protocol VideosDataStore {
  var monumentId: String? { get set }
}

class VideosInteractor: VideosBusinessLogic, VideosDataStore {
  
  // MARK: - Public

  var monumentId: String?
  var monumentVideos: [MonumentVideo] = []
  var monumentAPI: MonumentAPI?
  
  // MARK: - Properties

  var presenter: VideosPresentationLogic?

  // MARK: - Public

  func doLoadData(request: Videos.LoadData.Request) {
    guard let monumentId = monumentId else {
      return
    }
    presenter?.presentLoadData(response: Videos.LoadData.Response(result: .loading))

    monumentAPI?.getVideos(monumentId: monumentId) { [weak self] result in
      guard let self = self else {
        return
      }
      switch result {
      case .success(let monumentVideos):
        self.monumentVideos = monumentVideos
        let response = Videos.LoadData.Response(result: .success(data: monumentVideos))
        self.presenter?.presentLoadData(response: response)
      case .failure(let error):
        let response = Videos.LoadData.Response(result: .error(error))
        self.presenter?.presentLoadData(response: response)
      }
    }
  }
  
  func doSelectedItem(request: Videos.SelectedItem.Request) {
    let response = Videos.SelectedItem.Response(video: monumentVideos[request.index])
    presenter?.presentSelectedItem(response: response)
  }
}
