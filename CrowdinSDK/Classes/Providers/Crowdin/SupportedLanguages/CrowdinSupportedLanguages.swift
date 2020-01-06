//
//  CrowdinSupportedLanguages.swift
//  CrowdinSDK
//
//  Created by Serhii Londar on 3/26/19.
//

import Foundation

class CrowdinSupportedLanguages {
    static let shared = CrowdinSupportedLanguages()
    let api = SupportedLanguagesAPI()
    
    fileprivate enum Strings: String {
        case SupportedLanguages
        case Crowdin
    }
    fileprivate enum Keys: String {
        case lastUpdatedDate = "CrowdinSupportedLanguages.lastUpdatedDate"
    }
    fileprivate var filePath: String {
        return CrowdinFolder.shared.path + String.pathDelimiter + Strings.Crowdin.rawValue + String.pathDelimiter + Strings.SupportedLanguages.rawValue + FileType.json.extension
    }
    
    var lastUpdatedDate: Date? {
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.lastUpdatedDate.rawValue)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.value(forKey: Keys.lastUpdatedDate.rawValue) as? Date
        }
    }
    var supportedLanguages: SupportedLanguagesResponse? {
        didSet {
            saveSupportedLanguages()
        }
    }
    
    init() {
        readSupportedLanguages()
        updateSupportedLanguagesIfNeeded()
    }
    
    func crowdinLanguageCode(for localization: String) -> String? {
        let language = supportedLanguages?.first(where: { $0.osxLocale == localization })
        return language?.crowdinCode
    }
    
    func updateSupportedLanguagesIfNeeded() {
        guard let lastUpdatedDate = lastUpdatedDate else {
            self.updateSupportedLanguages()
            return
        }
        if Date().timeIntervalSince(lastUpdatedDate) > 7 * 24 * 60 * 60 {
            self.updateSupportedLanguages()
        }
    }
    
    func updateSupportedLanguages() {
        api.getSupportedLanguages { (supportedLanguages, error) in
            guard error == nil else { return }
            guard let supportedLanguages = supportedLanguages else { return }
            self.supportedLanguages = supportedLanguages
            self.lastUpdatedDate = Date()
        }
    }
    
    func saveSupportedLanguages() {
        guard let data = try? JSONEncoder().encode(supportedLanguages) else { return }
        try? data.write(to: URL(fileURLWithPath: filePath), options: Data.WritingOptions.atomic)
    }
    
    func readSupportedLanguages() {
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: filePath)) else { return }
        self.supportedLanguages = try? JSONDecoder().decode(SupportedLanguagesResponse.self, from: data)
    }
}
