// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum Localization {
  internal static var audioguideToolbarText: String { Localization.tr("Localizable", "audioguide_toolbar_text") }
  internal static var backButton: String { Localization.tr("Localizable", "back_button") }
  internal static var dialogErrorButtonCancel: String { Localization.tr("Localizable", "dialog_error_button_cancel") }
  internal static var dialogErrorButtonRetry: String { Localization.tr("Localizable", "dialog_error_button_retry") }
  internal static var dialogErrorMessage: String { Localization.tr("Localizable", "dialog_error_message") }
  internal static var dialogErrorTitle: String { Localization.tr("Localizable", "dialog_error_title") }
  internal static var dialogSelectlanguagePositive: String { Localization.tr("Localizable", "dialog_selectlanguage_positive") }
  internal static var dialogSelectlanguageText: String { Localization.tr("Localizable", "dialog_selectlanguage_text") }
  internal static var galleryEmptystateText: String { Localization.tr("Localizable", "gallery_emptystate_text") }
  internal static var galleryToolbarText: String { Localization.tr("Localizable", "gallery_toolbar_text") }
  internal static var howItWorksHeader: String { Localization.tr("Localizable", "how_it_works_header") }
  internal static var howItWorksInfo: String { Localization.tr("Localizable", "how_it_works_info") }
  internal static var howItWorksLanguage: String { Localization.tr("Localizable", "how_it_works_language") }
  internal static var howItWorksMunitic: String { Localization.tr("Localizable", "how_it_works_munitic") }
  internal static var howItWorksToolbar: String { Localization.tr("Localizable", "how_it_works_toolbar") }
  internal static var mainMonumentsButton: String { Localization.tr("Localizable", "main_monuments_button") }
  internal static var mainScannerButton: String { Localization.tr("Localizable", "main_scanner_button") }
  internal static var mainTitle: String { Localization.tr("Localizable", "main_title") }
  internal static var mapErrorText: String { Localization.tr("Localizable", "map_error_text") }
  internal static var mapNotAddress: String { Localization.tr("Localizable", "map_not_address") }
  internal static var monumentListToolbarText: String { Localization.tr("Localizable", "monument_list_toolbar_text") }
  internal static var panoramaRowText: String { Localization.tr("Localizable", "panorama_row_text") }
  internal static var scannerInvalidQrcodeInfo: String { Localization.tr("Localizable", "scanner_invalid_qrcode_info") }
  internal static var scannerInvalidQrcodeTitle: String { Localization.tr("Localizable", "scanner_invalid_qrcode_title") }
  internal static var scannerPermissionsButton: String { Localization.tr("Localizable", "scanner_permissions_button") }
  internal static var scannerPermissionsText: String { Localization.tr("Localizable", "scanner_permissions_text") }
  internal static var videosEmptystateText: String { Localization.tr("Localizable", "videos_emptystate_text") }
  internal static var videosToolbarText: String { Localization.tr("Localizable", "videos_toolbar_text") }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension Localization {

  static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
      let selectedLanguage = UserDefaultsManager.shared.language
    guard let path = Bundle.main.path(forResource: selectedLanguage, ofType: "lproj"),
    let bundle = Bundle(path: path) else { return "" }
    return NSLocalizedString(key, tableName: table, bundle: bundle, value: "", comment: "")
  }

}
