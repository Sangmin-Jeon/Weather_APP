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
        currentRegion.font = UIFont().happiness(size: 40, type: .bold)
        currentRegion.textColor = .white
        currentRegion.layer.shadowColor = UIColor.black.cgColor
        currentRegion.layer.shadowOffset = CGSize(width: 0, height: 1)
        currentRegion.layer.shadowOpacity = 0.5
        currentRegion.layer.shadowRadius = 1
        return currentRegion
    }()
    private let temperatureLabel: UILabel = { // 기온
        let temperatureLabel = UILabel()
        temperatureLabel.font = UIFont().happiness(size: 15, type: .regular)
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
        pressureLabel.font = UIFont().happiness(size: 15, type: .regular)
        pressureLabel.layer.shadowColor = UIColor.black.cgColor
        pressureLabel.layer.shadowOffset = CGSize(width: 0, height: 1)
        pressureLabel.layer.shadowOpacity = 0.5
        pressureLabel.layer.shadowRadius = 1
        return pressureLabel
    }()
    private let humidityLabel: UILabel = { // 습도
        let humidityLabel = UILabel()
        humidityLabel.textColor = .white
        humidityLabel.font = UIFont().happiness(size: 15, type: .regular)
        humidityLabel.layer.shadowColor = UIColor.black.cgColor
        humidityLabel.layer.shadowOffset = CGSize(width: 0, height: 1)
        humidityLabel.layer.shadowOpacity = 0.5
        humidityLabel.layer.shadowRadius = 1
        return humidityLabel
    }()
    private let descriptionLabel: UILabel = { // 날씨 정보
        let descriptionLabel = UILabel()
        descriptionLabel.textColor = .white
        descriptionLabel.font = UIFont().happiness(size: 15, type: .regular)
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
        weatherTableView.backgroundColor = .clear
        return weatherTableView
    }()
    private let animationView_1: LottieAnimationView = {
        // Lottie파일 다운받아 사용
        let animationView = LottieAnimationView(name: "FullBackgroundLottie")
        animationView.contentMode = .scaleAspectFill
        return animationView
    }()
    private let animationView_2: LottieAnimationView = {
        // Lottie파일 다운받아 사용
        let animationView = LottieAnimationView(name: "backgroundLottie")
        animationView.layer.cornerRadius = CGFloat(15)
        animationView.contentMode = .scaleAspectFill
        return animationView
    }()
    
    private let viewModel = MainViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        #if targetEnvironment(simulator)
        // 시뮬레이터일 경우 서울로 고정
        viewModel.getWeatherData(latitude: 37.5665, longitude: 126.9780)
        viewModel.getHourlyWeatherData(latitude: 37.5665, longitude: 126.9780)
        #else
        self.getLocation()
        #endif
        
        weatherTableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: "WeatherTableViewCell")
        weatherTableView.backgroundColor = .white.withAlphaComponent(0.5)
        weatherTableView.separatorStyle = .none

        self.setupLayout()
        self.bindData()
        self.bindTableView()
        
        self.animationView_1.play()
        self.animationView_1.loopMode = .loop
        self.animationView_2.play()
        self.animationView_2.loopMode = .loop
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.animationView_1.stop()
        self.animationView_2.stop()
    }

    
    private func setupLayout() {
        view.addSubview(animationView_1)
        animationView_1.addSubview(weatherTableView)
        weatherTableView.addSubview(headerView)
        headerView.addSubview(cardView)
        cardView.addSubview(animationView_2)
        cardView.addSubview(weatherIconImageView)
        cardView.addSubview(currentRegion)
        cardView.addSubview(temperatureLabel)
        cardView.addSubview(pressureLabel)
        cardView.addSubview(humidityLabel)
        cardView.addSubview(descriptionLabel)

        animationView_1.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
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
        
        animationView_2.snp.makeConstraints { make in
            make.height.equalTo(300)
            make.width.equalToSuperview()
        }
        
        currentRegion.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(rightOffset)
        }
        
        weatherIconImageView.snp.makeConstraints { make in
            make.top.equalTo(currentRegion.snp.bottom).offset(8)
            make.trailing.equalToSuperview().offset(rightOffset)
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
        // 현재 날씨 정보 표시
        viewModel.weatherData
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] data in
                guard let self = self else { return }
                if let first = data.weather.first,
                   let url = URL(string: "https://openweathermap.org/img/wn/\(first.icon)@2x.png") {
                    self.weatherIconImageView.kf.setImage(with: url)
                    
                    self.currentRegion.text = data.name
                    self.temperatureLabel.text = "온도 \(data.main.temp.kelvinToCelsius())°C"
                    self.pressureLabel.text = "기압 \(data.main.pressure) hPa"
                    self.humidityLabel.text = "습도 \(data.main.humidity)%"
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
    
    // GPS정보 받아 오기
    func getLocation() {
        curLocation.subscribe(
            onNext: { [weak self] location in
                guard let self = self else { return }
                // 위도, 경도
                if let lat = location[.lat], let lon = location[.lon] {
                    self.viewModel.getWeatherData(latitude: lat, longitude: lon)
                    self.viewModel.getHourlyWeatherData(latitude: lat, longitude: lon)
                }
            },
            onError: { [weak self] error in
                guard let self = self else { return }
                self.errorMessage.onNext(error.localizedDescription)
            }
        )
        .disposed(by: disposeBag)
    }
    
}

extension MainViewController {
    // MARK: 테이블 뷰 데이터 바인딩
    func bindTableView() {
        // weatherSections, 테이블뷰에 바인딩
        let dataSource = RxTableViewSectionedReloadDataSource<WeatherSectionModel>(configureCell: { (_, tableView, indexPath, element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherTableViewCell") as! WeatherTableViewCell
            cell.updateCell(key: element.date, value: element.weatherItems)
            cell.backgroundColor = .clear
            return cell
        }, titleForHeaderInSection: { dataSource, sectionIndex in
            dataSource[sectionIndex].header
        })
        
        // weatherList를 WeatherSectionModel 배열로 변환
        viewModel.weatherList
            .map { dict in
                let items = dict.map { WeatherItemModel(date: $0.key, weatherItems: $0.value) }
                let sorted = items.sorted(by: { $0.date < $1.date })
                return [WeatherSectionModel(header: "일기예보", items: sorted)]
            }
            .bind(to: viewModel.weatherSections)
            .disposed(by: disposeBag)
        
        // weatherSections, weatherTableView에 바인딩
        viewModel.weatherSections
            .bind(to: weatherTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        // 선택된 cell 처리
        weatherTableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                self.weatherTableView.deselectRow(at: indexPath, animated: false)
                
                viewModel.getSelctedItemIndex(index: indexPath.row) { [weak self] item in
                    let detailViewController = DetailViewController()
                    detailViewController.weatherData = item
                    self?.present(detailViewController, animated: true, completion: nil)
                    
                }
                
            })
            .disposed(by: disposeBag)
        
//        viewModel.weatherList
//            .map { $0.sorted(by: { $0.key < $1.key }) } // dict 정렬
//            .bind(to: weatherTableView.rx.items(
//                cellIdentifier: "WeatherTableViewCell",
//                cellType: WeatherTableViewCell.self)
//            ) { _, element, cell in
//                let (key, value) = element
//                cell.backgroundColor = .clear
//                cell.updateCell(key: key, value: value)
//
//            }
//            .disposed(by: disposeBag)
        
            
    }
}
