//
//  DTOs.swift
//  descubrevillalba
//
//  Created by Antonio Moreno on 13/03/2022.
//

import Foundation

public struct MonumentDetailsDTO: Codable {
  let id: String
  let nombreES: String
  let nombreEN: String
  let nombreFR: String
  let descripcionES: String
  let descripcionEN: String
  let descripcionFR: String
  let direccion: String
  let imagenPrincipalUrl: String
  let imagenCeldaUrl: String
  
  enum CodingKeys: String, CodingKey {
    case id
    case nombreES
    case nombreEN
    case nombreFR
    case descripcionES
    case descripcionEN
    case descripcionFR
    case direccion
    case imagenPrincipalUrl
    case imagenCeldaUrl
  }
}

public struct MonumentVideoDTO: Codable {
  let videoUrl: String
  let nombreES: String
  let nombreFR: String
  let nombreEN: String
  
  enum CodingKeys: String, CodingKey {
    case videoUrl
    case nombreES
    case nombreFR
    case nombreEN
  }
}

public struct MonumentPhotoDTO: Codable {
  let imagenUrl: String
  let esPanorama: String
  
  enum CodingKeys: String, CodingKey {
    case imagenUrl
    case esPanorama
  }
}

public struct MonumentAudioDTO: Codable {
  let urlES: String
  let urlFR: String
  let urlEN: String
  let imagenUrl: String
  
  enum CodingKeys: String, CodingKey {
    case urlES
    case urlFR
    case urlEN
    case imagenUrl
  }
}
