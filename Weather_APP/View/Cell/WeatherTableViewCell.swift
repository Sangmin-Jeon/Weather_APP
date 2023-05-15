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
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(8)
            make.bottom.equalTo(contentView.snp.bottom).offset(-8)
            make.leading.equalTo(contentView.snp.leading).offset(leftOffset)
            make.trailing.equalTo(contentView.snp.trailing).offset(rightOffset)
            make.height.greaterThanOrEqualTo(44)
        }
    }
    
    // Cell 항목 업데이트
    func updateCell(item: ForecastWeatherModel.WeatherItem) {
        self.titleLabel.text = item.dt_txt
        
    }
    
}
