//
//  Bundle+Crowdin.swift
//  CrowdinSDK
//
//  Created by Serhii Londar on 3/19/19.
//

import Foundation

// MARK: - Extension for reading Crowdin SDK configuration values from Info.plist.
extension Bundle {
    /// Crowdin CDN hash value.
    var crowdinHash: String? {
        return infoDictionary?["CrowdinHash"] as? String
    }
    
    /// Supported localizations for current application on crowdin server.
    var cw_localizations: [String]? {
        return infoDictionary?["CrowdinLocalizations"] as? [String]
    }
    
    /// Crowdin project key.
    var projectKey: String? {
        return infoDictionary?["CrowdinProjectKey"] as? String
    }
    
    /// Array of strigns file names.
    var crowdinStringsFileNames: [String]? {
        return infoDictionary?["CrowdinStringsFileNames"] as? [String]
    }
    
    /// Array of plurals file names.
    var crowdinPluralsFileNames: [String]? {
        return infoDictionary?["CrowdinPluralsFileNames"] as? [String]
    }
    
    /// Source language for current project on crowdin server.
    var crowdinSourceLanguage: String? {
        return infoDictionary?["CrowdinSourceLanguage"] as? String
    }
}
