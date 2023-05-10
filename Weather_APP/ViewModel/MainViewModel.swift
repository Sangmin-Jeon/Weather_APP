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
    
    let weatherData = BehaviorRelay<WeatherData?>(value: nil)
    let errorMessage = PublishSubject<String>()
    
    //날씨 데이터 불러오기
    func setWeatherData(latitude: Double, longitude: Double) {
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
}

extension NetworkManager {
    func getWeather(latitude: Double, longitude: Double) -> Observable<WeatherData> {
        let path = String("/data/2.5/weather")
        let parameters: Parameters = [
            "lat": latitude,
            "lon": longitude,
            "appid": apiKey
        ]
        
        return NetworkManager.shared.get(path: path, parameters: parameters)
    }
}
