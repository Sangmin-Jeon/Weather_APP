//
//  APIManager.swift
//  Weather_APP
//
//  Created by 전상민 on 2023/05/11.
//

import Foundation

class APIManager {
    var apiKey: String = ""
    
    static let shared = APIManager()
    
    init() {
        getApiKey()
    }
    
    func getApiKey() {
        if let _apiKey = Bundle.main.infoDictionary?["API_KEY"] as? String {
            apiKey = _apiKey
        }
        else {
            print("API Key not found")
        }
    }
}
