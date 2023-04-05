//
//  DetailInteractor.swift
//  descubrevillalba
//
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import FirebaseStorage

protocol DetailBusinessLogic {
  func doLoadData(request: Detail.LoadData.Request)
  func doAudioSelected(request: Detail.AudioSelected.Request)
  func doTrackClickVideo(request: Detail.TrackClickVideo.Request)
}

protocol DetailDataStore {
  var monumentId: String? { get set }
  var monumentDetails: MonumentDetails? { get set }
  var validCode: Bool? { get set }
}

class DetailInteractor: DetailBusinessLogic, DetailDataStore {

  var monumentId: String?
  var monumentDetails: MonumentDetails?
  var monumentAPI: MonumentAPI?
  var validCode: Bool?
  
  // MARK: - Properties

  var presenter: DetailPresentationLogic?

  // MARK: - Public

  func doLoadData(request: Detail.LoadData.Request) {
    guard let monumentId = monumentId else {
      presenter?.presentLoadData(response: Detail.LoadData.Response(result: .invalidCode))
      return
    }
    AnalyticsManager.shared.trackMonumentDetails(monumentId: monumentId)
    presenter?.presentLoadData(response: Detail.LoadData.Response(result: .loading))

    monumentAPI?.getMonumentsDetails(monumentId: monumentId) { [weak self] result in
      guard let self = self else {
        return
      }
      switch result {
      case .success(let monumentDetails):
        guard let monumentDetails = monumentDetails else {
          return
        }
        self.monumentDetails = monumentDetails
        let response = Detail.LoadData.Response(result: .success(data: monumentDetails))
        self.presenter?.presentLoadData(response: response)
      case .failure(let error):
        let response = Detail.LoadData.Response(result: .error(error))
        self.presenter?.presentLoadData(response: response)
      }
    }
  }

  func doAudioSelected(request: Detail.AudioSelected.Request) {
    guard let monumentId = monumentId else {
      return
    }
    AnalyticsManager.shared.trackAudioGuiaView(monumentId: monumentId)
    presenter?.presentAudioSelected(response: Detail.AudioSelected.Response(result: .loading))

    monumentAPI?.getAudios(monumentId: monumentId) { [weak self] result in
      guard let self = self else {
        return
      }
      switch result {
      case .success(let data):
        self.downloadAudio(data: data)
      case .failure(let error):
        let response = Detail.AudioSelected.Response(result: .error(error))
        self.presenter?.presentAudioSelected(response: response)
      }
    }
  }
  
  func doTrackClickVideo(request: Detail.TrackClickVideo.Request) {
    guard let monumentId = monumentId else {
      return
    }
    AnalyticsManager.shared.trackClickVideo(monumentId: monumentId)
  }

  // MARK: - Private
  
  private func downloadAudio(data: MonumentAudio) {
    let reference = StorageRef.storageRef?.child(data.audioUrl) ?? StorageReference()
    
    reference.downloadURL { (url, error) in
      if let downloadUrl = url {
        let item = AudioItem(audioUrl: downloadUrl, imageUrl: data.imageUrl, root: "/images/")
        let response = Detail.AudioSelected.Response(result: .success(data: item))
        self.presenter?.presentAudioSelected(response: response)
      } else {
        let response = Detail.AudioSelected.Response(result: .error(NetworkingError.unknown))
        self.presenter?.presentAudioSelected(response: response)
      }
    }
    
  }
}
