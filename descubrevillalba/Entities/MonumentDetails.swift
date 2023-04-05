//
//  MonumentDetails.swift
//  descubrevillalba
//
//  Created by Antonio Moreno on 07/03/2022.
//

import Foundation

public struct MonumentDetails {
  let identifier: String
  let name: String
  let description: String
  let address: String
  let mainImageUrl: String
  let cellImageUrl: String
}

public struct MonumentVideo {
  let identifier: Int
  let videoUrl: String
  let name: String
}

public struct MonumentPhoto {
  let identifier: Int
  let photoUrl: String
  let esPanorama: Bool
}

public struct MonumentAudio {
  let imageUrl: String
  let audioUrl: String
}

public enum Language: String {
  case spanish = "spanish"
  case english = "english"
  case french = "french"
}
