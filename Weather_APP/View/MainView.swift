//
//  MainView.swift
//  Weather_APP
//
//  Created by 전상민 on 4/1/24.
//

import UIKit
import RxSwift
import RxDataSources
import SnapKit
import Lottie

class MainView: UIView {
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
    
    func getWeatherTableView() -> UITableView {
        return weatherTableView
    }
    
    private let animationView_1: LottieAnimationView = {
        let animationView = LottieAnimationView(name: "FullBackgroundLottie")
        animationView.contentMode = .scaleAspectFill
        return animationView
    }()
    private let animationView_2: LottieAnimationView = {
        let animationView = LottieAnimationView(name: "backgroundLottie")
        animationView.layer.cornerRadius = CGFloat(15)
        animationView.contentMode = .scaleAspectFill
        return animationView
    }()
    
    var infoData: MainInfo? {
        willSet(new) {
            updateLayout(data: new)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        weatherTableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: "WeatherTableViewCell")
        weatherTableView.backgroundColor = .white.withAlphaComponent(0.5)
        weatherTableView.separatorStyle = .none
        
        setupLayout()
        
        self.animationView_1.play()
        self.animationView_1.loopMode = .loop
        self.animationView_2.play()
        self.animationView_2.loopMode = .loop
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    deinit {
        self.animationView_1.stop()
        self.animationView_2.stop()
    }
    
    
    private func setupLayout() {
        self.addSubview(animationView_1)
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
    
    private func updateLayout(data: MainInfo?) {
        guard let data = data else { return }
        self.weatherIconImageView.kf.setImage(with: data.imgUrl)
        self.currentRegion.text = data.name
        self.temperatureLabel.text = data.temp
        self.pressureLabel.text = data.pressure
        self.humidityLabel.text = data.humidity
        self.descriptionLabel.text = data.desc

    }

}

