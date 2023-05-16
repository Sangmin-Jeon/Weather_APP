//
//  MainViewController.swift
//  Weather_APP
//
//  Created by 전상민 on 2023/05/10.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import SnapKit
import Kingfisher
import Lottie

class MainViewController: ViewController {
    private let headerView: UIView = {
        let headerView = UIView()
        return headerView
    }()
    private let cardView: UIView = {
        let cardView = UIView()
        cardView.backgroundColor = .blue.withAlphaComponent(0.8)
        cardView.layer.cornerRadius = CGFloat(15)
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cardView.layer.shadowOpacity = 0.5
        cardView.layer.shadowRadius = 4
        // cardView.clipsToBounds = true // true일때 shadow 잘림
        return cardView
    }()
    private let currentRegion: UILabel = { // 지역이름
        let currentRegion = UILabel()
        currentRegion.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        currentRegion.textColor = .white
        currentRegion.layer.shadowColor = UIColor.black.cgColor
        currentRegion.layer.shadowOffset = CGSize(width: 0, height: 1)
        currentRegion.layer.shadowOpacity = 0.5
        currentRegion.layer.shadowRadius = 1
        return currentRegion
    }()
    private let temperatureLabel: UILabel = { // 기온
        let temperatureLabel = UILabel()
        temperatureLabel.textColor = .white
        temperatureLabel.layer.shadowColor = UIColor.black.cgColor
        temperatureLabel.layer.shadowOffset = CGSize(width: 0, height: 1)
        temperatureLabel.layer.shadowOpacity = 0.5
        temperatureLabel.layer.shadowRadius = 1
        return temperatureLabel
    }()
    private let pressureLabel: UILabel = { // 기압
        let pressureLabel = UILabel()
        pressureLabel.textColor = .white
        pressureLabel.layer.shadowColor = UIColor.black.cgColor
        pressureLabel.layer.shadowOffset = CGSize(width: 0, height: 1)
        pressureLabel.layer.shadowOpacity = 0.5
        pressureLabel.layer.shadowRadius = 1
        return pressureLabel
    }()
    private let humidityLabel: UILabel = { // 습도
        let humidityLabel = UILabel()
        humidityLabel.textColor = .white
        humidityLabel.layer.shadowColor = UIColor.black.cgColor
        humidityLabel.layer.shadowOffset = CGSize(width: 0, height: 1)
        humidityLabel.layer.shadowOpacity = 0.5
        humidityLabel.layer.shadowRadius = 1
        return humidityLabel
    }()
    private let descriptionLabel: UILabel = { // 날씨 정보
        let descriptionLabel = UILabel()
        descriptionLabel.textColor = .white
        descriptionLabel.layer.shadowColor = UIColor.black.cgColor
        descriptionLabel.layer.shadowOffset = CGSize(width: 0, height: 1)
        descriptionLabel.layer.shadowOpacity = 0.5
        descriptionLabel.layer.shadowRadius = 1
        return descriptionLabel
    }()
    private let weatherIconImageView: UIImageView = { // 날씨 아이콘 이미지
        let weatherIconImageView = UIImageView()
        weatherIconImageView.layer.shadowColor = UIColor.black.cgColor
        weatherIconImageView.layer.shadowOffset = CGSize(width: 0, height: 1)
        weatherIconImageView.layer.shadowOpacity = 0.5
        weatherIconImageView.layer.shadowRadius = 1
        weatherIconImageView.contentMode = .scaleAspectFill
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
    private let animationView: LottieAnimationView = {
        // Lottie파일 다운받아 사용
        let animationView = LottieAnimationView(name: "backgroundLottie")
        animationView.layer.cornerRadius = CGFloat(15)
        animationView.contentMode = .scaleAspectFill
        return animationView
    }()
    
    private let viewModel = MainViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherTableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: "WeatherTableViewCell")
        weatherTableView.backgroundColor = .white.withAlphaComponent(0.5)
        weatherTableView.separatorStyle = .none

        self.setupLayout()
        self.bindData()
        self.bindTableView()
        
        self.animationView.play()
        self.animationView.loopMode = .loop
        
        // 위도, 경도 임시
        viewModel.getWeatherData(latitude: 37.5665, longitude: 126.9780)
        viewModel.getHourlyWeatherData(latitude: 37.5665, longitude: 126.9780)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.animationView.stop()
    }

    
    private func setupLayout() {
        view.addSubview(weatherTableView)
        weatherTableView.addSubview(headerView)
        headerView.addSubview(cardView)
        cardView.addSubview(animationView)
        cardView.addSubview(weatherIconImageView)
        cardView.addSubview(currentRegion)
        cardView.addSubview(temperatureLabel)
        cardView.addSubview(pressureLabel)
        cardView.addSubview(humidityLabel)
        cardView.addSubview(descriptionLabel)

        weatherTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        headerView.snp.makeConstraints { make in
            make.top.equalTo(weatherTableView)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(300)
            make.width.equalToSuperview()
        }
        
        cardView.snp.makeConstraints { make in
            make.height.equalTo(300)
            make.width.equalTo(headerView).offset(rightOffset * 2)
            make.centerX.equalToSuperview()
        }
        
        animationView.snp.makeConstraints { make in
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
                cell.backgroundColor = .clear
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
