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
    private let headerView: UIView = {
        let headerView = UIView()
        return headerView
    }()
    private let currentRegion: UILabel = { // 지역이름
        let currentRegion = UILabel()
        currentRegion.font = UIFont.systemFont(ofSize: 40, weight: .bold)
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
        weatherTableView.isScrollEnabled = true
        weatherTableView.showsVerticalScrollIndicator = false
        weatherTableView.bounces = false
        return weatherTableView
    }()
    
    private let viewModel = MainViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherTableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: "WeatherTableViewCell")
        weatherTableView.separatorStyle = .none

        self.setupLayout()
        self.bindData()
        self.bindTableView()
        
        // 위도, 경도 임시
        viewModel.getWeatherData(latitude: 37.5665, longitude: 126.9780)
        viewModel.getHourlyWeatherData(latitude: 37.5665, longitude: 126.9780)
    }

    
    private func setupLayout() {
        view.addSubview(weatherTableView)
        weatherTableView.addSubview(headerView)
        headerView.addSubview(weatherIconImageView)
        headerView.addSubview(currentRegion)
        headerView.addSubview(temperatureLabel)
        headerView.addSubview(pressureLabel)
        headerView.addSubview(humidityLabel)
        headerView.addSubview(descriptionLabel)

        weatherTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        headerView.snp.makeConstraints { make in
            make.top.equalTo(weatherTableView)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(300)
            make.width.equalToSuperview()
        }
        
        currentRegion.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(leftOffset)
        }
        
        weatherIconImageView.snp.makeConstraints { make in
            make.top.equalTo(currentRegion.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(100)
        }
        
        temperatureLabel.snp.makeConstraints { make in
            make.top.equalTo(weatherIconImageView.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(leftOffset)
        }
        
        pressureLabel.snp.makeConstraints { make in
            make.top.equalTo(temperatureLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(leftOffset)
        }
        
        humidityLabel.snp.makeConstraints { make in
            make.top.equalTo(pressureLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(leftOffset)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(humidityLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(leftOffset)
        }
        
        weatherTableView.tableHeaderView = headerView
        
    }
    
    // MARK: 현재 날씨데이터 바인딩
    private func bindData() {
        // 날씨 아미지 표시
        viewModel.weatherData
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] data in
                guard let self = self else { return }
                if let first = data.weather.first,
                   let url = URL(string: "https://openweathermap.org/img/wn/\(first.icon)@2x.png") {
                    self.weatherIconImageView.kf.setImage(with: url)
                    
                    self.currentRegion.text = data.name
                    self.temperatureLabel.text = "온도 \(data.main.temp.kelvinToCelsius())°C"
                    self.pressureLabel.text = "\(data.main.pressure) hPa"
                    self.humidityLabel.text = "\(data.main.humidity)%"
                    self.descriptionLabel.text = "현재 날씨 \(String(first.description))입니다."
                }
            })
            .disposed(by: disposeBag)
        
//        viewModel.weatherData
//            .compactMap { $0 }
//            .map { "습도 : \($0.main.humidity)%" }
//            .bind(to: humidityLabel.rx.text)
//            .disposed(by: disposeBag)
        
        // 에러 메세지 처리 팝업
        viewModel.errorMessage
            .flatMap { [weak self] errorMessage -> Observable<PopupType> in
                guard let self = self else { return .empty() }
                return self.showPopup(
                    title: errorMessage,
                    message: "",
                    confirm: "확인"
                )
            }
            .subscribe(onNext: { state in
                if state == .confirm {
                    // 확인
                }
                else {
                    // 취소
                }
            })
            .disposed(by: disposeBag)
    
    }
    
    // MARK: 테이블 뷰 데이터 바인딩
    func bindTableView() {
        // weatherList, weatherTableView 데이터 바인딩
        viewModel.weatherList
            .map { $0.sorted(by: { $0.key < $1.key }) } // dict 정렬
            .bind(to: weatherTableView.rx.items(
                cellIdentifier: "WeatherTableViewCell",
                cellType: WeatherTableViewCell.self)
            ) { _, element, cell in
                let (key, value) = element
                cell.updateCell(key: key, value: value)
                
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
        
            
    }
    
}
