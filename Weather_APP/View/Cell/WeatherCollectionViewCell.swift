//
//  WeatherCollectionViewCell.swift
//  Weather_APP
//
//  Created by 전상민 on 2023/05/23.
//

import UIKit
import RxSwift
import SnapKit
import Kingfisher

class WeatherCollectionViewCell: UICollectionViewCell {
    let background: UIView = {
        let background = UIView()
        background.layer.cornerRadius = 25
        background.backgroundColor = UIColor(named: "SkyBlue")!.withAlphaComponent(0.8)
        return background
    }()
    
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .white
        titleLabel.font = UIFont().happiness(size: 14, type: .regular)
        return titleLabel
    }()
    
    let weatherImage: UIImageView = {
        let weatherImage = UIImageView()
        weatherImage.contentMode = .scaleAspectFill
        return weatherImage
    }()
    
    let tempLabel: UILabel = {
        let tempLabel = UILabel()
        tempLabel.textColor = .white
        tempLabel.font = UIFont().happiness(size: 14, type: .regular)
        return tempLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLayout() {
        contentView.addSubview(background)
        background.addSubview(weatherImage)
        background.addSubview(titleLabel)
        background.addSubview(tempLabel)
        
        background.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            
        }
        
        tempLabel.snp.makeConstraints { make in
            make.top.equalTo(background.snp.top).offset(10)
            make.centerX.equalToSuperview()
            
        }
        
        weatherImage.snp.makeConstraints { make in
            make.top.equalTo(tempLabel.snp.bottom).offset(0)
            make.height.width.equalTo(40)
            make.centerX.equalToSuperview()
            
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(weatherImage.snp.bottom).offset(0)
            make.centerX.equalToSuperview()
        }
        
    }
    
    func updateCell(item: ForecastWeatherModel.WeatherItem) {
        if let weather = item.weather.first,
           let url = URL(string: "https://openweathermap.org/img/wn/\(weather.icon)@2x.png") {
            weatherImage.kf.setImage(with: url)
        }
        titleLabel.text = item.dt_txt.convertHour()
        tempLabel.text = "\(item.main.temp.kelvinToCelsius())°C"
        
    }
    
}

