//
//  MainViewModel.swift
//  Weather_APP
//
//  Created by 전상민 on 2023/05/10.
//

import Foundation
import UIKit
import RxSwift
import RxDataSources
import Alamofire
import RxRelay

struct WeatherItemModel {
    let date: String
    let weatherItems: [ForecastWeatherModel.WeatherItem]
}

struct WeatherSectionModel {
    let header: String
    var items: [WeatherItemModel]
}

extension WeatherSectionModel: SectionModelType {
    typealias Item = WeatherItemModel
    
    init(original: WeatherSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}

class MainViewModel {
    private let disposeBag = DisposeBag()

    let errorMessage = PublishSubject<String>()
    let weatherData = BehaviorRelay<WeatherModel?>(value: nil)
    var weatherList = BehaviorRelay<[String : [ForecastWeatherModel.WeatherItem]]>(value: [:])
    let weatherSections = BehaviorRelay<[WeatherSectionModel]>(value: [])


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
                    guard let self = self else { return }
                    // self.weatherList.accept(weatherData.list)
                    self.setDateList(items: weatherData.list)
                    
                },
                onError: { [weak self] error in
                    self?.errorMessage.onNext(error.localizedDescription)
                }
            )
            .disposed(by: disposeBag)
    }
    
    // 선택된 Cell의 항목 처리
    func getSelctedItemIndex(index: Int, completion: ([String : [ForecastWeatherModel.WeatherItem]]) -> ()) {
        let sorted = self.weatherList.value.sorted(by: { $0.key < $1.key })
        let (day, dayNTime) = sorted[index]
        completion([day : dayNTime])
        
    }
    
    // 일간 시간대별 예보 일별로 묶음 리스트
    func setDateList(items: [ForecastWeatherModel.WeatherItem]) {
        var result = [String: [ForecastWeatherModel.WeatherItem]]()
        items.forEach { item in
            let dateString = item.dt_txt.toDateString()
            if let arr = result[dateString] {
                var newArr = arr
                newArr.append(item)
                result.updateValue(newArr, forKey: dateString)
            }
            else {
                result.updateValue([item], forKey: dateString)
            }
        }
        // let sortedResult = result.sorted(by: { $0.key < $1.key })
        // let dictResult = Dictionary(uniqueKeysWithValues: sortedResult)
        
        weatherList.accept(result)
        
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
        
        return get(path: path, parameters: parameters)
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
        return get(path: path, parameters: parameters)
    }
    
    // MARK: 현재 대기 정보
    func getAirPollution(latitude: Double, longitude: Double) -> Observable<AirPollutionModel> {
        let path = String("/data/2.5/air_pollution")
        let parameters: Parameters = [
            "lat": latitude,
            "lon": longitude,
            "appid": APIManager.shared.apiKey,
            "lang": "kr"
        ]
        return get(path: path, parameters: parameters)
    }
}


