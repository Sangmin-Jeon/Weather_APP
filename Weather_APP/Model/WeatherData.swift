//
//  WeatherData.swift
//  Weather_APP
//
//  Created by 전상민 on 2023/05/11.
//

import Foundation

struct WeatherData: Codable {
    let coord: Coordinate
    let weather: [Weather]
    let base: String
    let main: Main
    let visibility: Int
    let wind: Wind
    let rain: Rain?
    let clouds: Clouds
    let dt: Int
    let sys: Sys
    let timezone: Int
    let id: Int
    let name: String
    let cod: Int
    
    struct Coordinate: Codable {
        let lon: Double
        let lat: Double
    }
    
    struct Weather: Codable {
        let id: Int
        let main: String
        let description: String
        let icon: String
    }
    
    struct Main: Codable {
        let temp: Double
        let feels_like: Double
        let temp_min: Double
        let temp_max: Double
        let pressure: Int
        let humidity: Int
        let sea_level: Int?
        let grnd_level: Int?
    }
    
    struct Wind: Codable {
        let speed: Double
        let deg: Int
        let gust: Double?
    }
    
    struct Rain: Codable {
        let h1: Double?

        enum CodingKeys: String, CodingKey {
            case h1 = "1h"
        }
    }
    
    struct Clouds: Codable {
        let all: Int
    }

    struct Sys: Codable {
        let type: Int
        let id: Int
        let country: String
        let sunrise: Int
        let sunset: Int
    }
}
