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
import Kingfisher

class MainViewController: ViewController {
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = false
        scrollView.isScrollEnabled = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    private let contentView: UIView = {
        let contentView = UIView(frame: CGRect.zero)
        return contentView
    }()
    
    private let currentRegion: UILabel = { // 지역이름
        let currentRegion = UILabel()
        return currentRegion
    }()
    private let temperatureLabel: UILabel = { // 기온
        let temperatureLabel = UILabel()
        return temperatureLabel
    }()
    private let pressureLabel: UILabel = { // 기압
        let pressureLabel = UILabel()
        return pressureLabel
    }()
    private let humidityLabel: UILabel = { // 습도
        let humidityLabel = UILabel()
        return humidityLabel
    }()
    private let descriptionLabel: UILabel = { // 날씨 정보
        let descriptionLabel = UILabel()
        return descriptionLabel
    }()
    private let weatherIconImageView: UIImageView = { // 날씨 아이콘 이미지
        let weatherIconImageView = UIImageView()
        return weatherIconImageView
    }()
    private let viewModel = MainViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupLayout()
        self.bindData()
        // 위도, 경도 임시
        viewModel.getWeatherData(latitude: 37.5665, longitude: 126.9780)
    }
    
    // UI 작성 함수
    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(weatherIconImageView)
        contentView.addSubview(currentRegion)
        contentView.addSubview(temperatureLabel)
        contentView.addSubview(pressureLabel)
        contentView.addSubview(humidityLabel)
        contentView.addSubview(descriptionLabel)
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalTo(descriptionLabel.snp.bottom).offset(16)
        }
        
        weatherIconImageView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(100)
        }
        
        currentRegion.snp.makeConstraints { make in
            make.top.equalTo(weatherIconImageView.snp.bottom).offset(8)
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
    
    }
    
    // 데이터 바인딩
    private func bindData() {
        viewModel.weatherData
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] data in
                if let first = data.weather.first,
                   let url = URL(string: "https://openweathermap.org/img/wn/\(first.icon)@2x.png") {
                    self?.weatherIconImageView.kf.setImage(with: url)
                }
            })
            .disposed(by: disposeBag)
        
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
        
        viewModel.errorMessage
            .subscribe(onNext: { [weak self] errorMessage in
                print("Error: \(errorMessage)")
            })
            .disposed(by: disposeBag)
    }
    
}
