//
//  DetailViewModel.swift
//  Weather_APP
//
//  Created by 전상민 on 2023/05/19.
//

import Foundation
import RxSwift
import Charts

struct TemperatureData {
    let dt: String
    let max: String
    let min: String
}

class DetailViewModel {
    
    let chartData = BehaviorSubject<[TemperatureData]>(value: [])
    
    func getchartData(data: [String : [ForecastWeatherModel.WeatherItem]]) {
        var setChartsData = [TemperatureData]()
        if let getFirst = data.first {
            let ( _, dateNTime) = getFirst
            dateNTime.forEach { item in
                let temp = TemperatureData(
                    dt: item.dt_txt,
                    max: item.main.temp_max.kelvinToCelsius(),
                    min: item.main.temp_min.kelvinToCelsius()
                )
                setChartsData.append(temp)
            }
            
            chartData.onNext(setChartsData)
        }
    }
    
    
}
