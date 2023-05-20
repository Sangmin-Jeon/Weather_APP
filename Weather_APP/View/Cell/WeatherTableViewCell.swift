//
//  WeatherTableViewCell.swift
//  Weather_APP
//
//  Created by 전상민 on 2023/05/13.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class WeatherTableViewCell: UITableViewCell {
    let cellBackgroundView: UIView = {
        let cellBackgroundView = UIView()
        cellBackgroundView.backgroundColor = .black.withAlphaComponent(0.1)
        cellBackgroundView.layer.cornerRadius = CGFloat(15)
        return cellBackgroundView
    }()
    
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont().happiness(size: 16, type: .bold)
        return titleLabel
    }()
    
    let maxTempLabel: UILabel = {
        let maxTempLabel = UILabel()
        maxTempLabel.font = UIFont().happiness(size: 12, type: .regular)
        return maxTempLabel
    }()
    
    let minTempLabel: UILabel = {
        let minTempLabel = UILabel()
        minTempLabel.font = UIFont().happiness(size: 12, type: .regular)
        return minTempLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayout()
    }
    
    private func setupLayout() {
        contentView.addSubview(cellBackgroundView)
        cellBackgroundView.addSubview(titleLabel)
        cellBackgroundView.addSubview(maxTempLabel)
        cellBackgroundView.addSubview(minTempLabel)
        
        cellBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(10) // top 간격을 10으로 설정
            make.bottom.equalTo(contentView.snp.bottom).offset(-10) // bottom 간격을 10으로 설정
            make.leading.equalTo(contentView.snp.leading).offset(leftOffset)
            make.trailing.equalTo(contentView.snp.trailing).offset(rightOffset)
            make.height.equalTo(50)
        }

        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(cellBackgroundView)
            make.leading.equalTo(cellBackgroundView.snp.leading).offset(leftOffset)
            make.top.greaterThanOrEqualTo(cellBackgroundView.snp.top)
            make.bottom.lessThanOrEqualTo(cellBackgroundView.snp.bottom)
        }

        maxTempLabel.snp.makeConstraints { make in
            make.centerY.equalTo(cellBackgroundView)
            make.trailing.equalTo(minTempLabel.snp.leading).offset(rightOffset)
        }
        
        minTempLabel.snp.makeConstraints { make in
            make.centerY.equalTo(cellBackgroundView)
            make.trailing.equalTo(cellBackgroundView.snp.trailing).offset(rightOffset)
        }
        
    }
    
    // Cell 항목 업데이트
    func updateCell(key: String, value: [ForecastWeatherModel.WeatherItem]) {
        self.titleLabel.text = key.convertMonthNDay()
        let (maxTemp, minTemp) = getMaxNMinTemp(value: value)
        self.maxTempLabel.text = "최고 \(maxTemp.kelvinToCelsius())°C"
        self.minTempLabel.text = "최저 \(minTemp.kelvinToCelsius())°C"
        
    }
    
    // 해당 날짜의 최고, 최저기온 찾기
    func getMaxNMinTemp(value: [ForecastWeatherModel.WeatherItem]) -> (Double, Double) {
        var maxArr = [Double]()
        var minArr = [Double]()
        value.forEach { item in
            maxArr.append(item.main.temp_max)
            minArr.append(item.main.temp_min)
        }
        
        return (maxArr.max() ?? 0.0, minArr.min() ?? 0.0)
    }
    
}
