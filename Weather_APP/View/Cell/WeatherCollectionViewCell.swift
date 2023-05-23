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
        background.layer.cornerRadius = 20
        background.backgroundColor = .black
        return background
    }()
    
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .white
        titleLabel.font = UIFont().happiness(size: 15, type: .regular)
        return titleLabel
    }()
    
    let weatherImage: UIImageView = {
        let weatherImage = UIImageView()
    
        return weatherImage
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
        
        background.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            
        }
        
        weatherImage.snp.makeConstraints { make in
            make.top.equalTo(background).offset(10)
            make.height.width.equalTo(50)
            make.centerX.equalToSuperview()
            
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(weatherImage.snp.bottom).offset(3)
            make.centerX.equalToSuperview()
            
        }
        
    }
    
    func updateCell(item: ForecastWeatherModel.WeatherItem) {
        if let weather = item.weather.first,
           let url = URL(string: "https://openweathermap.org/img/wn/\(weather.icon)@2x.png") {
            weatherImage.kf.setImage(with: url)
        }
        titleLabel.text = item.dt_txt.convertHour()
        
    }
    
}

