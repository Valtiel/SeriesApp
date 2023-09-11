//
//  PListAppConfiguration.swift
//  SeriesApp
//
//  Created by César Rosales on 04/09/2023.
//

import Foundation

enum ConfigurationKey: String {
    case ServerURL = "Server URL"
    case ApiKey = "API Key"
}

struct PlistAppConfiguration {
    
    static let mainPlistPath = Bundle.main.path(forResource: "Configuration", ofType: "plist")
    
    static func getValue(for key: String) -> String? {
        guard let path = PlistAppConfiguration.mainPlistPath,
              let resourceFileDictionary = NSDictionary(contentsOfFile: path) else {
            return nil
        }
        return resourceFileDictionary[key] as? String
    }
}

extension PlistAppConfiguration {
    
    static func getServerURL() -> String {
        return getValue(for: ConfigurationKey.ServerURL.rawValue)!
    }
    
    static func getApiKey() -> String {
        return getValue(for: ConfigurationKey.ApiKey.rawValue)!
    }

}

