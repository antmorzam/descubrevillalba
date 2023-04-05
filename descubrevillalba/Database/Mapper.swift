//
//  Mapper.swift
//  descubrevillalba
//
//  Created by Antonio Moreno on 20/03/2022.
//

import Foundation

public class Mapper {
    let defaultManager = UserDefaultsManager.shared

  func getUserLanguage() -> String {
    let currentLocale = defaultManager.language
    if isSpanish(currentLocale) {
      return Language.spanish.rawValue
    } else if isFrench(currentLocale) {
      return Language.french.rawValue
    } else {
      return Language.english.rawValue
    }
  }
    
  private func isSpanish(_ language: String) -> Bool {
    ["es", "ca", "gl", "eu"].contains(language)
  }
  
  private func isFrench(_ language: String) -> Bool {
    language == "fr"
  }
  
  public func map(_ monumentDetails: [MonumentDetailsDTO]) -> [MonumentDetails] {
    var items: [MonumentDetails] = []
    for item in monumentDetails {
      let language = getUserLanguage()
      let description = language == Language.spanish.rawValue ? item.descripcionES :
        language == Language.french.rawValue ? item.descripcionFR :
        item.descripcionEN
      let nombre = language == Language.spanish.rawValue ? item.nombreES :
        language == Language.french.rawValue ? item.nombreFR :
        item.nombreEN
      let monumentDetail = MonumentDetails(identifier: item.id,
                                           name: nombre,
                                           description: description,
                                           address: item.direccion,
                                           mainImageUrl: item.imagenPrincipalUrl,
                                           cellImageUrl: item.imagenCeldaUrl)
      items.append(monumentDetail)
    }
    return items
  }

  public func map(_ dto: MonumentDetailsDTO, monumentId: String) -> MonumentDetails {
    let language = getUserLanguage()
    let description = language == Language.spanish.rawValue ? dto.descripcionES :
      language == Language.french.rawValue ? dto.descripcionFR :
      dto.descripcionEN
    let nombre = language == Language.spanish.rawValue ? dto.nombreES :
      language == Language.french.rawValue ? dto.nombreFR :
      dto.nombreEN
    return MonumentDetails(identifier: dto.id,
                           name: nombre,
                           description: description,
                           address: dto.direccion,
                           mainImageUrl: dto.imagenPrincipalUrl,
                           cellImageUrl: dto.imagenCeldaUrl)
  }
  
  public func map(_ videos: [MonumentVideoDTO]) -> [MonumentVideo] {
    let language = getUserLanguage()
    var identifier = 0
    var monumentsVideo: [MonumentVideo] = []
    for dto in videos {
      let videoName = language == Language.spanish.rawValue ? dto.nombreES :
        language == Language.french.rawValue ? dto.nombreFR :
        dto.nombreEN
      let monumentVideo = MonumentVideo(identifier: identifier,
                                        videoUrl: dto.videoUrl,
                                        name: videoName)
      monumentsVideo.append(monumentVideo)
      identifier += 1
    }
    return monumentsVideo.sorted { $0.name < $1.name }
  }
  
  public func map(_ photos: [MonumentPhotoDTO]) -> [MonumentPhoto] {
    var identifier = 0
    var monumentsPhoto: [MonumentPhoto] = []
    for dto in photos {
      let monumentPhoto = MonumentPhoto(identifier: identifier,
                                        photoUrl: dto.imagenUrl,
                                        esPanorama: map(dto.esPanorama))
      monumentsPhoto.append(monumentPhoto)
      identifier += 1
    }
    return monumentsPhoto
  }
  
  public func map(_ audio: MonumentAudioDTO) -> MonumentAudio {
    let language = getUserLanguage()
    let audioUrl = language == Language.spanish.rawValue ? audio.urlES :
      language == Language.french.rawValue ? audio.urlFR :
      audio.urlEN
    return MonumentAudio(imageUrl: audio.imagenUrl, audioUrl: audioUrl)
  }
  
  public func map(_ string: String) -> Bool {
    string == "si" ? true : false
  }
}
