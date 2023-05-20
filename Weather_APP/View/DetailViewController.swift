//
//  DetailViewController.swift
//  Weather_APP
//
//  Created by 전상민 on 2023/05/19.
//

import UIKit
import RxSwift
import SnapKit
import Charts


class DetailViewController: ViewController {
    private let viewModel = DetailViewModel()
    private let disposeBag = DisposeBag()
    
    var weatherData = [String : [ForecastWeatherModel.WeatherItem]]()
    var xAxisList = [String]()
    
    let titleBackgroundView: UIView = {
        let titleBackgroundView = UIView()
        return titleBackgroundView
    }()
    
    let titleView: UILabel = {
        let titleView = UILabel()
        titleView.font = UIFont().happiness(size: 20, type: .bold)
        titleView.textColor = .black
        return titleView
    }()
    
    let chartBackgroundView: UIView = {
        let chartBackgroundView = UIView()
        chartBackgroundView.backgroundColor = .white
        chartBackgroundView.layer.cornerRadius = CGFloat(15)
        chartBackgroundView.layer.shadowColor = UIColor.black.cgColor
        chartBackgroundView.layer.shadowOffset = CGSize(width: 0, height: 2)
        chartBackgroundView.layer.shadowOpacity = 0.5
        chartBackgroundView.layer.shadowRadius = 4
        return chartBackgroundView
    }()
    
    let chartView: LineChartView = {
        let chartView = LineChartView()
        chartView.noDataFont = .systemFont(ofSize: 10)
        chartView.noDataText = "날씨 데이터가 없습니다."
        chartView.chartDescription.text = "최고/최저기온이 같을 경우 파랑색으로 표시"
        
        chartView.noDataTextColor = .darkGray
        chartView.backgroundColor = .clear
        
        chartView.doubleTapToZoomEnabled = false
        chartView.highlightPerTapEnabled = true
        chartView.rightAxis.enabled = false
        chartView.leftAxis.enabled = true
        chartView.extraRightOffset = 50
        
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.leftAxis.drawGridLinesEnabled = false
        chartView.animate(yAxisDuration: 0.75, easingOption: .easeInBounce)
        
        let marker = CustomMarkerView()
        chartView.marker = marker
        
        return chartView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        view.backgroundColor = .white
        viewModel.getchartData(data: weatherData)
        setupLayout()
        bindData()
        
    }
    
    private func setupLayout() {
        view.addSubview(contentView)
        contentView.addSubview(titleView)
        contentView.addSubview(chartBackgroundView)
        chartBackgroundView.addSubview(chartView)
        
        contentView.snp.updateConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleView.text = weatherData.first?.key.convertMonthNDay()
        titleView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(10)
        }
        
        chartBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(titleView.snp.bottom).offset(20)
            make.height.equalTo(250)
            make.leading.equalToSuperview().offset(leftOffset)
            make.trailing.equalToSuperview().offset(rightOffset)
        }
        
        chartView.snp.makeConstraints { make in
            make.centerY.equalTo(chartBackgroundView)
            make.height.equalTo(220)
            make.leading.equalToSuperview().offset(leftOffset)
            make.trailing.equalToSuperview().offset(rightOffset + 20)
        }
        
    }
    
    private func bindData() {
        viewModel.chartData
            .map { (values) -> LineChartData in
                let highEntries = values.enumerated().map { (index, temp) -> ChartDataEntry in
                    if let getTemp = Double(temp.max) {
                        self.xAxisList.append(temp.dt.convertHour())
                        return ChartDataEntry(x: Double(index), y: getTemp)
                    }
                    return ChartDataEntry()
                   
                }
                
                let lowEntries = values.enumerated().map { (index, temp) -> ChartDataEntry in
                    if let getTemp = Double(temp.min) {
                        if self.xAxisList.isEmpty {
                            self.xAxisList.append(temp.dt.convertHour())
                        }
                        return ChartDataEntry(x: Double(index), y: getTemp)
                    }
                    return ChartDataEntry()
                }
                
                let highSet = LineChartDataSet(entries: highEntries, label: "최고기온")
                highSet.setColor(.red)
                highSet.setCircleColor(.red)
                highSet.circleRadius = 5.0
                highSet.drawCirclesEnabled = true
                highSet.mode = .cubicBezier
                
                let lowSet = LineChartDataSet(entries: lowEntries, label: "최저기온")
                lowSet.setColor(.blue)
                lowSet.setCircleColor(.blue)
                lowSet.circleRadius = 5.0
                lowSet.drawCirclesEnabled = true
                lowSet.mode = .cubicBezier
                
                self.chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: self.xAxisList)
                
                return LineChartData(dataSets: [highSet, lowSet])
            }
            .bind(to: chartView.rx.data)
            .disposed(by: disposeBag)
        
    }

}


extension Reactive where Base: LineChartView {
    var data: Binder<LineChartData> {
        return Binder(self.base) { view, data in
            view.data = data
        }
    }
}
