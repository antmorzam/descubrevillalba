//
//  MonumentDetails.swift
//  descubrevillalba
//
//  Created by Antonio Moreno on 13/03/2022.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class MonumentAPI {

  let db = Firestore.firestore()
  private let mapper = Mapper()

  // MARK: - Call to details
  public func getMonumentsDetails(monumentId: String,
                                  completion: @escaping(Result<MonumentDetails?, NetworkingError>) -> Void) {
    let monumentsDetailsDocumentRef = db.collection("puntos").document(monumentId)
    db.settings.isPersistenceEnabled = false
    
    monumentsDetailsDocumentRef.getDocument { (document, error) in
      guard let document = document else {
        completion(.failure(.unknown))
        return
      }
      
      if let _ = error {
        completion(.failure(.unknown))
        return
      }
      do {
        if let dto = try document.data(as: MonumentDetailsDTO.self) {
          let details = self.mapper.map(dto, monumentId: monumentId)
            completion(.success(details))
            return
        } else {
          completion(.failure(.unknown))
          return
        }
      } catch {
        completion(.failure(.unknown))
        return
      }
    }
  }
  
  // MARK: - Call to monuments
  public func getMonuments(completion: @escaping(Result<[MonumentDetails], NetworkingError>) -> Void) {
    var monumentDetailsDTO: [MonumentDetailsDTO] = []
    let monumentsDetailsDocumentRef = db.collection("puntos").order(by: "orden")
    
    db.settings.isPersistenceEnabled = false
    
    monumentsDetailsDocumentRef.getDocuments() { (snapshot, error) in
      guard let snapshot = snapshot else {
        completion(.failure(.unknown))
        return
      }
      
      if let _ = error {
        completion(.failure(.unknown))
        return
      }
      
      if snapshot.metadata.isFromCache == true && snapshot.documents.isEmpty {
        completion(.failure(.unknown))
        return
      }
      
      for document in snapshot.documents {
        do {
          if let dto = try document.data(as: MonumentDetailsDTO.self) {
            monumentDetailsDTO.append(dto)
          } else {
            completion(.failure(.unknown))
            return
          }
        } catch {
          completion(.failure(.unknown))
          return
        }
      }
      let monumentDetails = self.mapper.map(monumentDetailsDTO)
      completion(.success(monumentDetails))
    }
  }
  
  // MARK: - Call to photos
  public func getPhotos(monumentId: String,
                        completion: @escaping(Result<[MonumentPhoto], NetworkingError>) -> Void) {
    var monumentPhotoDTO: [MonumentPhotoDTO] = []
    let monumentPhotoDocumentRef = db.collection("fotos").document(monumentId).collection("listado").order(by: "imagenUrl")
    
    db.settings.isPersistenceEnabled = false
    
    monumentPhotoDocumentRef.getDocuments() { (snapshot, error) in
      guard let snapshot = snapshot else {
        completion(.failure(.unknown))
        return
      }
      
      if let _ = error {
        completion(.failure(.unknown))
        return
      }
      
      if snapshot.metadata.isFromCache == true && snapshot.documents.isEmpty {
        completion(.failure(.unknown))
        return
      }
      
      for document in snapshot.documents {
        do {
          if let dto = try document.data(as: MonumentPhotoDTO.self) {
            monumentPhotoDTO.append(dto)
          } else {
            completion(.failure(.unknown))
            return
          }
        } catch {
          completion(.failure(.unknown))
          return
        }
      }
      let monumentPhotos = self.mapper.map(monumentPhotoDTO)
      completion(.success(monumentPhotos))
    }
  }
  
  // MARK: - Call to videos
  public func getVideos(monumentId: String,
                        completion: @escaping(Result<[MonumentVideo], NetworkingError>) -> Void) {
    var monumentVideoDTO: [MonumentVideoDTO] = []
    let monumentVideoDocumentRef = db.collection("videos").document(monumentId).collection("listado")
    
    db.settings.isPersistenceEnabled = false
    
    monumentVideoDocumentRef.getDocuments() { (snapshot, error) in
      guard let snapshot = snapshot else {
        completion(.failure(.unknown))
        return
      }
      
      if let _ = error {
        completion(.failure(.unknown))
        return
      }
      
      if snapshot.metadata.isFromCache == true && snapshot.documents.isEmpty {
        completion(.failure(.unknown))
        return
      }
      
      for document in snapshot.documents {
        do {
          if let dto = try document.data(as: MonumentVideoDTO.self) {
            monumentVideoDTO.append(dto)
          } else {
            completion(.failure(.unknown))
            return
          }
        } catch {
          completion(.failure(.unknown))
          return
        }
      }
      let monumentVideos = self.mapper.map(monumentVideoDTO)
      completion(.success(monumentVideos))
    }
  }
  
  // MARK: - Call to audios
  public func getAudios(monumentId: String,
                        completion: @escaping(Result<MonumentAudio, NetworkingError>) -> Void) {

    let monumentAudioDocumentRef = db.collection("audios").document(monumentId)
    
    db.settings.isPersistenceEnabled = false
    
    monumentAudioDocumentRef.getDocument() { (document, error) in
      guard let document = document else {
        completion(.failure(.unknown))
        return
      }
      
      if let _ = error {
        completion(.failure(.unknown))
        return
      }
      
      if document.metadata.isFromCache == true {
        completion(.failure(.unknown))
        return
      }
      
      do {
        if let dto = try document.data(as: MonumentAudioDTO.self) {
          let audios = self.mapper.map(dto)
          completion(.success(audios))
        } else {
          completion(.failure(.unknown))
          return
        }
      } catch {
        completion(.failure(.unknown))
        return
      }
    }
  }
}
