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
        return titleLabel
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
            make.trailing.equalTo(cellBackgroundView.snp.trailing).offset(rightOffset)
            make.top.greaterThanOrEqualTo(cellBackgroundView.snp.top)
            make.bottom.lessThanOrEqualTo(cellBackgroundView.snp.bottom)
        }
    }
    
    // Cell 항목 업데이트
    func updateCell(key: String, value: [ForecastWeatherModel.WeatherItem]) {
        self.titleLabel.text = key.convertMonthNDay()
        
        
    }
    
}
