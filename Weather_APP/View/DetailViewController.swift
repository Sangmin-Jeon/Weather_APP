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
    
    let titleView: UILabel = {
        let titleView = UILabel()
        titleView.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        titleView.textColor = .black
        return titleView
    }()
    let chartView: LineChartView = {
        let chartView = LineChartView()
        chartView.noDataFont = .systemFont(ofSize: 10)
        chartView.noDataText = "날씨 데이터가 없습니다."
        chartView.chartDescription.text = "최고/최저기온이 같을 경우 파랑색으로 표시"
        
        chartView.noDataTextColor = .darkGray
        chartView.backgroundColor = .white
        
        chartView.doubleTapToZoomEnabled = false
        chartView.highlightPerTapEnabled = false
        chartView.rightAxis.enabled = false
        chartView.leftAxis.enabled = false
        
        chartView.xAxis.labelPosition = .bottom
        chartView.animate(yAxisDuration: 0.75, easingOption: .easeInBounce)
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
        contentView.addSubview(chartView)
        
        contentView.snp.updateConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleView.text = weatherData.first?.key.convertMonthNDay()
        titleView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(10)
        }
        
        chartView.snp.makeConstraints { make in
            make.top.equalTo(titleView.snp.bottom).offset(20)
            make.height.equalTo(200)
            make.leading.equalToSuperview().offset(leftOffset)
            make.trailing.equalToSuperview().offset(rightOffset)
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
                highSet.mode = .cubicBezier
                
                let lowSet = LineChartDataSet(entries: lowEntries, label: "최저기온")
                lowSet.setColor(.blue)
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
