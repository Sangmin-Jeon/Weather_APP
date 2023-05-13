//
//  ForecastWeatherModel.swift
//  Weather_APP
//
//  Created by 전상민 on 2023/05/13.
//

// WeatherForecastData 구조체 설명:
// OpenWeatherMap API: https://api.openweathermap.org/data/2.5/forecast
//
// 주요 프로퍼티:
// - cod: API 응답의 상태 코드 (예: "200")
// - message: 응답 메시지 (0: 성공)
// - cnt: 요청된 시간 범위 내의 예보 개수
// - list: 예보 데이터 목록
// - city: 예보 대상 도시 정보

// WeatherItem 구조체 설명:
// - dt: 예보 시간 (UTC, Unix Timestamp)
// - main: 기온, 기압, 습도 등 기본 날씨 정보
// - weather: 날씨 상태 정보 (예: 맑음, 비, 구름 등)
// - clouds: 구름 정보 (전체 구름량 비율)
// - wind: 바람 정보 (풍속, 풍향, 돌풍 등)
// - visibility: 가시 거리 (미터)
// - pop: 강수 확률 (0~1)
// - rain: 강수량 정보 (1시간 간격)
// - sys: 예보 데이터의 일부 기본 정보 (예: 낮/밤 구분)
// - dt_txt: 예보 시간 (UTC, 텍스트 형식)

// 기존 WeatherData 모델에서 사용한 구조체:
// - Coordinate: 위도와 경도 정보
// - Weather: 날씨 상태 정보
// - Main: 기온, 기압, 습도 등 기본 날씨 정보
// - Wind: 바람 정보 (풍속, 풍향, 돌풍 등)
// - Rain: 강수량 정보
// - Clouds: 구름 정보 (전체 구름량 비율)

// 추가된 City 구조체 설명:
// - id: 도시의 고유 ID
// - name: 도시 이름
// - coord: 도시의 위도와 경도 정보
// - country: 국가 코드 (2글자, 예: "KR")
// - population: 도시 인구
// - timezone: 도시와 UTC 시간 차이 (초)
// - sunrise: 일출 시간 (UTC, Unix Timestamp)
// - sunset: 일몰 시간 (UTC, Unix Timestamp)


import Foundation

struct ForecastWeatherModel: Codable {
    let cod: String
    let message: Double
    let cnt: Int
    let list: [WeatherItem]
    let city: City
    
    struct WeatherItem: Codable {
        let dt: Int
        let main: Main
        let weather: [Weather]
        let clouds: Clouds
        let wind: Wind
        let visibility: Int
        let pop: Double
        let rain: Rain?
        let sys: Sys
        let dt_txt: String
    }
    
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
        let sea_level: Int?
        let grnd_level: Int?
        let humidity: Int
        let temp_kf: Double?
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
        let pod: String
    }
    
    struct City: Codable {
        let id: Int
        let name: String
        let coord: Coordinate
        let country: String
        let population: Int
        let timezone: Int
        let sunrise: Int
        let sunset: Int
    }
}
