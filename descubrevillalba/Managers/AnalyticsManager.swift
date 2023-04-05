//
//  AnalyticsManager.swift
//  descubrevillalba
//
//  Created by Antonio Moreno on 29/03/2022.
//

import Foundation
import FirebaseAnalytics

protocol EventProtocol {
  var name: CustomEvent { get set }
  var params: [String: String] { get set }
}

@propertyWrapper
struct Event: EventProtocol {
  var name: CustomEvent
  var params: [String: String] = [:]
  
  var wrappedValue: Event {
    return Event(name: name, params: params)
  }
}

struct UserProfileModel {
  let language: Language
}

protocol AnalyticsManagerProtocol {
    func trackEvent(_ event: EventProtocol)
}

class AnalyticsManager: AnalyticsManagerProtocol {
  static let shared = AnalyticsManager()
  let defaultManager = UserDefaultsManager.shared
  
  func trackEvent(_ event: EventProtocol) {
    Analytics.logEvent(event.name.rawValue, parameters: event.params)
  }
  
  // OPEN APP = Language and SO
  func trackAppOpen() {
    trackLanguage()
  }

  // MARK: - Language
  private func trackLanguage() {
    let appLanguage = getLanguageAnalytics()
    let formattedLanguage = getFormattedLanguage(appLanguage)
    let parameters: [String: String] = [CustomParameter.USER_LANGUAGE.rawValue: formattedLanguage]
    let event = Event(name: CustomEvent.IDIOMA, params: parameters)
    trackEvent(event)
  }
  
  // MARK: - Screen View
  func trackScreenView(_ screen: Screen) {
    let parameters: [String: String] = [CustomParameter.NOMBRE_PANTALLA.rawValue: screen.rawValue]
    let event = Event(name: CustomEvent.VIEW_SCREEN, params: parameters)
    trackEvent(event)
  }

  // MARK: - Monument Details Screen View
  func trackMonumentDetails(monumentId: String) {
    trackScreenView(Screen.MONUMENT_DETAILS)
    let parameters: [String: String] = [CustomParameter.MONUMENT_ID.rawValue: getMonumentTrackingNameById(monumentId)]
    let event = Event(name: CustomEvent.VIEW_MONUMENT_DETAILS, params: parameters)
    trackEvent(event)
  }
  
  // MARK: - Monument Item Click
  func trackClickMonumentItem(monumentId: String) {
    let parameters: [String: String] = [CustomParameter.MONUMENT_ID.rawValue: getMonumentTrackingNameById(monumentId)]
    let event = Event(name: CustomEvent.CLICK_MONUMENT_LIST, params: parameters)
    trackEvent(event)
  }
  
  // MARK: - Video Click
  func trackClickVideo(monumentId: String) {
    let parameters: [String: String] = [CustomParameter.MONUMENT_ID.rawValue: getMonumentTrackingNameById(monumentId)]
    let event = Event(name: CustomEvent.CLICK_VIDEO, params: parameters)
    trackEvent(event)
  }
  
  // MARK: - Audio Guia View
  func trackAudioGuiaView(monumentId: String) {
    let appLanguage = getLanguageAnalytics()
    if appLanguage == Language.spanish {
      trackAudioGuiaSpanish(monumentId)
    } else if appLanguage == Language.french {
      trackAudioGuiaFrench(monumentId)
    } else {
      trackAudioGuiaEnglish(monumentId)
    }
  }
  
  func trackAudioGuiaSpanish(_ monumentId: String) {
    let parameters: [String: String] = [CustomParameter.MONUMENT_ID.rawValue: getMonumentTrackingNameById(monumentId)]
    let event = Event(name: CustomEvent.AUDIOGUIA_ESP, params: parameters)
    trackEvent(event)
  }
  
  func trackAudioGuiaFrench(_ monumentId: String) {
    let parameters: [String: String] = [CustomParameter.MONUMENT_ID.rawValue: getMonumentTrackingNameById(monumentId)]
    let event = Event(name: CustomEvent.AUDIOGUIA_FRA, params: parameters)
    trackEvent(event)
  }
  
  func trackAudioGuiaEnglish(_ monumentId: String) {
    let parameters: [String: String] = [CustomParameter.MONUMENT_ID.rawValue: getMonumentTrackingNameById(monumentId)]
    let event = Event(name: CustomEvent.AUDIOGUIA_ENG, params: parameters)
    trackEvent(event)
  }
  
  private func getLanguageAnalytics() -> Language {
    let language = defaultManager.language
    if isSpanish(language: language) {
      return Language.spanish
    } else if isFrench(language: language) {
      return Language.french
    } else {
      return Language.english
    }
  }
}

enum CustomEvent: String {
  case CLICK_VIDEO = "click_video"
  case CLICK_MONUMENT_LIST = "punto_de_interes_clickado"
  case VIEW_MONUMENT_DETAILS = "punto_de_interes_view"
  case VIEW_SCREEN = "pantalla"
  case IDIOMA = "idioma"
  case SISTEMA_OPERATIVO = "sistema_operativo"
  case AUDIOGUIA_ESP = "audioguia_esp"
  case AUDIOGUIA_FRA = "audioguia_fra"
  case AUDIOGUIA_ENG = "audioguia_eng"
}

enum CustomParameter: String {
  case NOMBRE_PANTALLA = "nombre_pantalla"
  case MONUMENT_ID = "id_monumento"
  case USER_LANGUAGE = "user_language"
  case SO = "so"
}

private func getMonumentTrackingNameById(_ monumentId: String) -> String {
  switch monumentId {
  case Monument.dv01castillo.rawValue:
    return "Iglesia"
  case Monument.dv02convento.rawValue:
    return "Convento"
  case Monument.dv03ermita.rawValue:
    return "Ermita"
  case Monument.dv04captrini.rawValue:
    return "Trinidad"
  case Monument.dv05capcerri.rawValue:
    return "Cerrillo"
  case Monument.dv06capreal.rawValue:
    return "Calle Real"
  case Monument.dv07capniche.rawValue:
    return "Niche"
  case Monument.dv08cappaterna.rawValue:
    return "Paterna"
  case Monument.dv09cslizcano.rawValue:
    return "Casa Lizcano"
  case Monument.dv10csbanco.rawValue:
    return "Casa Pacheco"
  case Monument.dv11csbotica.rawValue:
    return "Casa canon"
  case Monument.dv12csromero.rawValue:
    return "Casa Romero Botejon"
  case Monument.dv13csespina.rawValue:
    return "Casa Espina"
  case Monument.dv14bodlanda.rawValue:
    return "Fdez de Landa"
  case Monument.dv15boddiezm.rawValue:
    return "Bodega diezmo"
  case Monument.dv16toralam.rawValue:
    return "Torre Alambique"
  case Monument.dv17tormolino.rawValue:
    return "Torre Molino"
  case Monument.dv18hospital.rawValue:
    return "Hosp Misericordia"
  case Monument.dv19ayunta.rawValue:
    return "Casa Osorno"
  case Monument.dv20nazareno.rawValue:
    return "Hdad Nazareno"
  case Monument.dv21rocio.rawValue:
    return "Hdad Rocio"
  case Monument.dv22carmen.rawValue:
    return "Hdad Carmen"
  default:
    return "Desconocido"
  }
}

enum Screen: String {
  case MAIN = "Pantalla Inicial"
  case HOW_IT_WORKS = "Como funciona"
  case MONUMENT_LIST = "Lista Puntos de Interes"
  case SCANNER = "Escaner"
  case SCAN_INVALID = "QR Invalido"
  case MONUMENT_DETAILS = "Detalle Punto Interes"
  case VIDEOS = "Videos"
  case GALLERY = "Galeria"
  case GALLERY_DETAILS = "Detalle Foto"
  case AUDIOGUIDE = "Audioguia"
}

enum Monument: String {
  case dv01castillo = "dv01-castillo"
  case dv02convento = "dv02-convento"
  case dv03ermita = "dv03-ermita"
  case dv04captrini = "dv04-cap-trini"
  case dv05capcerri = "dv05-cap-cerri"
  case dv06capreal = "dv06-cap-real"
  case dv07capniche = "dv07-cap-niche"
  case dv08cappaterna = "dv08-cap-paterna"
  case dv09cslizcano = "dv09-cs-lizcano"
  case dv10csbanco = "dv10-cs-banco"
  case dv11csbotica = "dv11-cs-botica"
  case dv12csromero = "dv12-cs-romero"
  case dv13csespina = "dv13-cs-espina"
  case dv14bodlanda = "dv14-bod-landa"
  case dv15boddiezm = "dv15-bod-diezm"
  case dv16toralam = "dv16-tor-alam"
  case dv17tormolino = "dv17-tor-molino"
  case dv18hospital = "dv18-hospital"
  case dv19ayunta = "dv19-ayunta"
  case dv20nazareno = "dv20-nazareno"
  case dv21rocio = "dv21-rocio"
  case dv22carmen = "dv22-carmen"
}

func isSpanish(language: String) -> Bool {
  [SPANISH_LANGUAGE, CATALAN_LANGUAGE, EUSKERA_LANGUAGE, GALICIAN_LANGUAGE].contains(language)
}

func isFrench(language: String) -> Bool {
  language == FRENCH_LANGUAGE
}

private let SPANISH_LANGUAGE = "es"
private let CATALAN_LANGUAGE = "ca"
private let EUSKERA_LANGUAGE = "eu"
private let GALICIAN_LANGUAGE = "gl"
private let FRENCH_LANGUAGE = "fr"

func getFormattedLanguage(_ language: Language) -> String {
  switch language {
  case .spanish:
    return "Espanol"
  case .english:
    return "Ingles"
  case .french:
    return "Frances"
  }
}
