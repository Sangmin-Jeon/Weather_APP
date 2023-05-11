//
//  MainViewController.swift
//  Weather_APP
//
//  Created by 전상민 on 2023/05/10.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class MainViewController: ViewController {
    private let currentRegion = UILabel()
    private let temperatureLabel = UILabel()
    private let pressureLabel = UILabel()
    private let humidityLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let weatherIconImageView = UIImageView()

    private let viewModel = MainViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupLayout()
        self.bindData()
        // 위도, 경도 임시
        viewModel.setWeatherData(latitude: 37.5665, longitude: 126.9780)
    }
    
    // UI 작성 함수
    private func setupLayout() {
        view.addSubview(currentRegion)
        view.addSubview(temperatureLabel)
        view.addSubview(pressureLabel)
        view.addSubview(humidityLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(weatherIconImageView)
        
        currentRegion.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.equalToSuperview().offset(16)
        }
        
        temperatureLabel.snp.makeConstraints { make in
            make.top.equalTo(currentRegion.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
        }
        
        pressureLabel.snp.makeConstraints { make in
            make.top.equalTo(temperatureLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
        }
        
        humidityLabel.snp.makeConstraints { make in
            make.top.equalTo(pressureLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(humidityLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
        }
        
        weatherIconImageView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(100)
        }
    }
    
    // 데이터 바인딩
    private func bindData() {
        viewModel.weatherData
            .compactMap { $0 }
            .map { "지역 : \($0.name)" }
            .bind(to: currentRegion.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.weatherData
            .compactMap { $0 }
            .map { "기온: \($0.main.temp)°C" }
            .bind(to: temperatureLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.weatherData
            .compactMap { $0 }
            .map { "기압: \($0.main.pressure) hPa" }
            .bind(to: pressureLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.weatherData
            .compactMap { $0 }
            .map { "습도 : \($0.main.humidity)%" }
            .bind(to: humidityLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.weatherData
            .compactMap { $0?.weather.first?.description }
            .bind(to: descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.weatherData
            .compactMap { $0?.weather.first?.icon }
            .subscribe(onNext: { [weak self] icon in
                
                
            })
            .disposed(by: disposeBag)
        
        viewModel.errorMessage
            .subscribe(onNext: { [weak self] errorMessage in
                print("Error: \(errorMessage)")
            })
            .disposed(by: disposeBag)
    }
    
}
