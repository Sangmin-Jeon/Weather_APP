//
//  WeatherModel.swift
//  Weather_APP
//
//  Created by 전상민 on 2023/05/11.
//

// WeatherData 구조체 설명:
// OpenWeatherMap API: https://api.openweathermap.org/data/2.5/weather
//
// 주요 프로퍼티:
// - coord: 도시의 좌표 (위도, 경도)
// - weather: 날씨 상태 정보 (예: 맑음, 비, 구름 등)
// - base: 내부 매개 변수
// - main: 기온, 기압, 습도 등 기본 날씨 정보
// - visibility: 가시 거리 (미터)
// - wind: 바람 정보 (풍속, 풍향, 돌풍 등)
// - rain: 강수량 정보 (1시간 간격)
// - clouds: 구름 정보 (전체 구름량 비율)
// - dt: 데이터 계산 시간 (UTC, Unix Timestamp)
// - sys: 일부 국가 및 도시 정보
// - timezone: 도시와 UTC 시간 차이 (초)
// - id: 도시의 고유 ID
// - name: 도시 이름
// - cod: API 응답의 상태 코드 (예: 200)

// Coordinate 구조체 설명:
// - lon: 경도
// - lat: 위도

// Weather 구조체 설명:
// - id: 날씨 상태의 고유 ID
// - main: 날씨 그룹 (예: Rain, Snow, Clear 등)
// - description: 날씨 상태에 대한 상세 설명 (예: light rain, clear sky 등)
// - icon: 날씨 아이콘 ID

// Main 구조체 설명:
// - temp: 기온 (Kelvin)
// - feels_like: 체감 온도 (Kelvin)
// - temp_min: 최저 기온 (Kelvin)
// - temp_max: 최고 기온 (Kelvin)
// - pressure: 대기압 (hPa)
// - humidity: 습도 (%)
// - sea_level: 해수면 대기압 (hPa, 옵션)
// - grnd_level: 지상 대기압 (hPa, 옵션)

// Wind 구조체 설명:
// - speed: 풍속 (m/s)
// - deg: 풍향 (도, 0-360)
// - gust: 돌풍 속도 (m/s, 옵션)

// Rain 구조체 설명:
// - h1: 최근 1시간 동안의 강수량 (mm)

// Clouds 구조체 설명:
// - all: 전체 구름량 비율 (%)

// Sys 구조체 설명:
// - type: 내부 매개 변수
// - id: 내부 매개 변수
// - country: 국가 코드 (2글자, 예: "KR")
// - sunrise: 일출 시


import Foundation

struct WeatherModel: Codable {
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
