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

enum MenuType: String {
    case temp = "기온"
    case pressure = "기압"
}

struct TemperatureData {
    let dt: String
    let temp: String?
    let pressure: Int?
    
    init(dt: String, temp: String? = nil, pressure: Int? = nil) {
        self.dt = dt
        self.temp = temp
        self.pressure = pressure
    }
}

class DetailViewModel {
    
    let chartData = BehaviorSubject<[TemperatureData]>(value: [])
    var weatherData = [String : [ForecastWeatherModel.WeatherItem]]()
    var weatherDataObservable: Observable<[SectionModel<String, ForecastWeatherModel.WeatherItem>]> {
        return Observable.just(weatherData.map { (key, value) -> SectionModel<String, ForecastWeatherModel.WeatherItem> in
            return SectionModel(model: key, items: value)
        })
    }
    var menuType: MenuType = .temp {
        didSet {
            self.getchartData(type: menuType, data: weatherData)
        }
    }
    
    func getchartData(type: MenuType, data: [String : [ForecastWeatherModel.WeatherItem]]) {
        var setChartsData = [TemperatureData]()
        var temp = TemperatureData(dt: "")
        if let getFirst = data.first {
            let ( _, dateNTime) = getFirst
            dateNTime.forEach { item in
                switch type {
                case .temp:
                    temp = TemperatureData(
                        dt: item.dt_txt,
                        temp: item.main.temp.kelvinToCelsius()
                    )
                case .pressure:
                    temp = TemperatureData(
                        dt: item.dt_txt,
                        pressure: item.main.pressure
                    )
                }
                setChartsData.append(temp)
            }
            
            chartData.onNext(setChartsData)
        }
    }
    
    
}
