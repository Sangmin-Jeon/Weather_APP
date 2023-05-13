//
//  MainViewModel.swift
//  Weather_APP
//
//  Created by 전상민 on 2023/05/10.
//

import Foundation
import UIKit
import RxSwift
import Alamofire
import RxRelay


class MainViewModel {
    private let disposeBag = DisposeBag()

    let errorMessage = PublishSubject<String>()
    let weatherData = BehaviorRelay<WeatherModel?>(value: nil)
    var weatherList = BehaviorRelay<[ForecastWeatherModel.WeatherItem]>(value: [])

    // 현재 날씨 데이터 불러오기
    func getWeatherData(latitude: Double, longitude: Double) {
        NetworkManager.shared.getWeather(latitude: latitude, longitude: longitude)
            .subscribe(
                onNext: { [weak self] weatherData in
                    self?.weatherData.accept(weatherData)
                },
                onError: { [weak self] error in
                    self?.errorMessage.onNext(error.localizedDescription)
                }
            )
            .disposed(by: disposeBag)
    }
     
    // Forecast 날씨 데이터 불러오기
    func getHourlyWeatherData(latitude: Double, longitude: Double) {
        NetworkManager.shared.getForecastWeather(latitude: latitude, longitude: longitude)
            .subscribe(
                onNext: { [weak self] weatherData in
                    self?.weatherList.accept(weatherData.list)
                },
                onError: { [weak self] error in
                    self?.errorMessage.onNext(error.localizedDescription)
                }
            )
            .disposed(by: disposeBag)
    }
    
    // 선택된 Cell의 항목 처리
    func getSelctedItemIndex(index: Int) {
        let item = self.weatherList.value[index]
        print(item)
        
    }
}

extension NetworkManager {
    // MARK: 현재 날씨 예보
    func getWeather(latitude: Double, longitude: Double) -> Observable<WeatherModel> {
        let path = String("/data/2.5/weather")
        let parameters: Parameters = [
            "lat": latitude,
            "lon": longitude,
            "appid": APIManager.shared.apiKey,
            "lang": "kr"
        ]
        
        return NetworkManager.shared.get(path: path, parameters: parameters)
    }
    
    // MARK: 5일간 날씨 예보
    func getForecastWeather(latitude: Double, longitude: Double) -> Observable<ForecastWeatherModel> {
        let path = String("/data/2.5/forecast")
        let parameters: Parameters = [
            "lat": latitude,
            "lon": longitude,
            "appid": APIManager.shared.apiKey,
            "lang": "kr"
        ]
        return NetworkManager.shared.get(path: path, parameters: parameters)
    }
}
