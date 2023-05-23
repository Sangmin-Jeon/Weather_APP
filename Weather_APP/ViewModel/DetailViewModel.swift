//
//  DetailViewModel.swift
//  Weather_APP
//
//  Created by 전상민 on 2023/05/19.
//

import Foundation
import RxSwift
import RxRelay
import RxDataSources
import Charts

struct TemperatureData {
    let dt: String
    let temp: String
}

class DetailViewModel {
    
    let chartData = BehaviorSubject<[TemperatureData]>(value: [])
    var weatherData = [String : [ForecastWeatherModel.WeatherItem]]()
    var weatherDataObservable: Observable<[SectionModel<String, ForecastWeatherModel.WeatherItem>]> {
        return Observable.just(weatherData.map { (key, value) -> SectionModel<String, ForecastWeatherModel.WeatherItem> in
            return SectionModel(model: key, items: value)
        })
    }
    
    func getchartData(data: [String : [ForecastWeatherModel.WeatherItem]]) {
        var setChartsData = [TemperatureData]()
        if let getFirst = data.first {
            let ( _, dateNTime) = getFirst
            dateNTime.forEach { item in
                let temp = TemperatureData(
                    dt: item.dt_txt,
                    temp: item.main.temp.kelvinToCelsius()
                )
                setChartsData.append(temp)
            }
            
            chartData.onNext(setChartsData)
        }
    }
    
    
}
