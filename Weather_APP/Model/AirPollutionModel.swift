//
//  AirPollutionModel.swift
//  Weather_APP
//
//  Created by 전상민 on 1/16/24.
//

import Foundation

struct AirPollutionModel: Codable {
    let coord: Coordinate
    let list: [AirQualityData]
    
    struct Coordinate: Codable {
        let lat: Double
        let lon: Double
    }

    struct AirQualityData: Codable {
        let dt: Int
        let main: Main
        let components: Components

        struct Main: Codable {
            let aqi: Int
        }

        struct Components: Codable {
            let co: Double
            let no: Double
            let no2: Double
            let o3: Double
            let so2: Double
            let pm2_5: Double
            let pm10: Double
            let nh3: Double
        }
        
    }
}
