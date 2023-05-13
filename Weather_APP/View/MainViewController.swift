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
    
    private let weatherTableView: UITableView = { // 날씨 List
        let weatherTableView = UITableView()
        weatherTableView.rowHeight = UITableView.automaticDimension
        weatherTableView.isScrollEnabled = false
        weatherTableView.showsVerticalScrollIndicator = false
        return weatherTableView
    }()
    
    private let viewModel = MainViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherTableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: "WeatherTableViewCell")

        self.setupLayout()
        self.bindData()
        self.bindTableView()
        
        // 위도, 경도 임시
        viewModel.getWeatherData(latitude: 37.5665, longitude: 126.9780)
        viewModel.getHourlyWeatherData(latitude: 37.5665, longitude: 126.9780)
    }

    
    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(weatherIconImageView)
        contentView.addSubview(currentRegion)
        contentView.addSubview(temperatureLabel)
        contentView.addSubview(pressureLabel)
        contentView.addSubview(humidityLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(weatherTableView)
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
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
        
        weatherTableView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-16)
            make.height.equalTo(0)
        }
        
    }
    
    // MARK: 현재 날씨데이터 바인딩
    private func bindData() {
        // 날씨 아미지 표시
        viewModel.weatherData
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] data in
                if let first = data.weather.first,
                   let url = URL(string: "https://openweathermap.org/img/wn/\(first.icon)@2x.png") {
                    self?.weatherIconImageView.kf.setImage(with: url)
                }
            })
            .disposed(by: disposeBag)
        
        // 지역 이름
        viewModel.weatherData
            .compactMap { $0 }
            .map { "지역 : \($0.name)" }
            .bind(to: currentRegion.rx.text)
            .disposed(by: disposeBag)
        
        // TODO: 절대온도 섭씨온도로 변환
        // 기온 정보
        viewModel.weatherData
            .compactMap { $0 }
            .map { "기온: \($0.main.temp.kelvinToCelsius())°C" }
            .bind(to: temperatureLabel.rx.text)
            .disposed(by: disposeBag)
        
        // 기압 정보
        viewModel.weatherData
            .compactMap { $0 }
            .map { "기압: \($0.main.pressure) hPa" }
            .bind(to: pressureLabel.rx.text)
            .disposed(by: disposeBag)
        
        // 습도 정보
        viewModel.weatherData
            .compactMap { $0 }
            .map { "습도 : \($0.main.humidity)%" }
            .bind(to: humidityLabel.rx.text)
            .disposed(by: disposeBag)
        
        // 날씨 정보
        viewModel.weatherData
            .compactMap { $0?.weather.first?.description }
            .bind(to: descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        // 에러 메세지 처리 팝업
        viewModel.errorMessage
            .flatMap { [weak self] errorMessage -> Observable<PopupType> in
                guard let self = self else { return .empty() }
                return self.showPopup(title: errorMessage, message: "", confirm: "확인")
            }
            .subscribe(onNext: { state in
                if state == .confirm {
                    
                }
            })
            .disposed(by: disposeBag)
    
    }
    
    // MARK: 테이블 뷰 데이터 바인딩
    func bindTableView() {
        // weatherList, weatherTableView 데이터 바인딩
        viewModel.weatherList
            .bind(to: weatherTableView.rx.items(
                cellIdentifier: "WeatherTableViewCell",
                cellType: WeatherTableViewCell.self)
            ) { _, item, cell in
                cell.updateCell(item: item)
                
            }
            .disposed(by: disposeBag)
        
        // 선택된 cell 처리
        weatherTableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                self.weatherTableView.deselectRow(at: indexPath, animated: true)
                viewModel.getSelctedItemIndex(index: indexPath.row)
                
            })
            .disposed(by: disposeBag)
        
        // weatherList 상태 구독
        viewModel.weatherList
            .subscribe { [weak self] item in
                guard let self = self else { return }
                self.setTableViewDynamicHeight(tableView: weatherTableView)
            }
            .disposed(by: disposeBag)
        
            
    }
    
}
