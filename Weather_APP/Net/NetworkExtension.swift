//
//  NetworkExtension.swift
//  Weather_APP
//
//  Created by 전상민 on 4/1/24.
//

import Foundation
import RxSwift
import Alamofire

private let weatherPath = String("/data/2.5/weather")// 상품 목록 경로
private let forecastWeatherlPath = String("/data/2.5/forecast") // 상품 목록 상세 내역 경로
private let airPollutionPath = String("/data/2.5/air_pollution")

extension NetworkManager {
    // MARK: 현재 날씨 예보
    func getWeather(myLocation: MyLocation) -> Observable<WeatherModel> {
        return get(
            path: weatherPath,
            myLocation: MyLocation(
                latitude: myLocation.latitude,
                longitude: myLocation.longitude
            )
        )
    }
    
    // MARK: 5일간 날씨 예보
    func getForecastWeather(myLocation: MyLocation) -> Observable<ForecastWeatherModel> {
        return get(
            path: forecastWeatherlPath,
            myLocation: MyLocation(
                latitude: myLocation.latitude,
                longitude: myLocation.longitude
            )
        )
    }
    
    // MARK: 현재 대기 정보
    func getAirPollution(myLocation: MyLocation) -> Observable<AirPollutionModel> {
        return get(
            path: airPollutionPath,
            myLocation: MyLocation(
                latitude: myLocation.latitude,
                longitude: myLocation.longitude
            )
        )
    }
    
}
