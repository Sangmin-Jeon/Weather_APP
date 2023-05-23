//
//  DetailViewController.swift
//  Weather_APP
//
//  Created by 전상민 on 2023/05/19.
//

import UIKit
import RxSwift
import RxDataSources
import SnapKit
import Charts


class DetailViewController: ViewController {
    private let viewModel = DetailViewModel()
    
    var weatherData = [String : [ForecastWeatherModel.WeatherItem]]()
    var xAxisList = [String]()
    
    let titleBackgroundView: UIView = {
        let titleBackgroundView = UIView()
        titleBackgroundView.backgroundColor = .white
        titleBackgroundView.layer.cornerRadius = CGFloat(15)
        titleBackgroundView.layer.shadowColor = UIColor.black.cgColor
        titleBackgroundView.layer.shadowOffset = CGSize(width: 0, height: 2)
        titleBackgroundView.layer.shadowOpacity = 0.5
        titleBackgroundView.layer.shadowRadius = 4
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
        chartView.chartDescription.text = "3시간 간격으로 기온을 표시"
        
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
    
    let weatherCollectionBackgroundView: UIView = {
        let weatherTableViewBackground = UIView()
        weatherTableViewBackground.backgroundColor = .black
        return weatherTableViewBackground
    }()
    
    let weatherCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 100, height: 100)
        let weatherTableView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        weatherTableView.showsHorizontalScrollIndicator = false
        weatherTableView.bounces = false
        weatherTableView.backgroundColor = .white
        return weatherTableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        viewModel.weatherData = weatherData
        view.backgroundColor = .white
        
        weatherCollectionView.register(WeatherCollectionViewCell.self, forCellWithReuseIdentifier: "WeatherCollectionViewCell")
        
        viewModel.getchartData(data: weatherData)
        setupLayout()
        bindData()
        bindCollectionView()
        
    }
    
    private func setupLayout() {
        view.addSubview(contentView)
        contentView.addSubview(titleBackgroundView)
        titleBackgroundView.addSubview(titleView)
        contentView.addSubview(chartBackgroundView)
        chartBackgroundView.addSubview(chartView)
        contentView.addSubview(weatherCollectionBackgroundView)
        weatherCollectionBackgroundView.addSubview(weatherCollectionView)
        
        contentView.snp.updateConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleBackgroundView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.leading.equalToSuperview().offset(leftOffset)
            make.trailing.equalToSuperview().offset(rightOffset)
            make.height.equalTo(50)
        }
        
        titleView.text = weatherData.first?.key.convertMonthNDay()
        titleView.snp.makeConstraints { make in
            make.centerY.equalTo(titleBackgroundView)
            make.leading.equalToSuperview().offset(10)
        }
        
        chartBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(titleBackgroundView.snp.bottom).offset(20)
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
        
        weatherCollectionBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(chartBackgroundView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(leftOffset)
            make.trailing.equalToSuperview().offset(rightOffset)
            make.height.equalTo(100) // Set height as 100
            
        }
        
        weatherCollectionView.snp.updateConstraints { make in
            make.edges.equalTo(weatherCollectionBackgroundView)
        }
        
        
    }
    
    private func bindData() {
        viewModel.chartData
            .map { (values) -> LineChartData in
                let temp = self.setChart(values: values)
                return LineChartData(dataSets: [temp])
            }
            .bind(to: chartView.rx.data)
            .disposed(by: disposeBag)
            
    }
    
    // chart데이터 및 UI 세팅
    private func setChart(values: [TemperatureData]) -> LineChartDataSet {
        // Chart에 표시할 데이터
        let highEntries = values.enumerated().map { (index, temp) -> ChartDataEntry in
            if let getTemp = Double(temp.temp) {
                self.xAxisList.append(temp.dt.convertHour())
                return ChartDataEntry(x: Double(index), y: getTemp)
            }
            return ChartDataEntry()
           
        }
        
        // Chart UI 정보 세팅
        let tempSet = LineChartDataSet(entries: highEntries, label: "기온정보")
        tempSet.setColor(.blue.withAlphaComponent(0.2))
        tempSet.setCircleColor(.gray)
        tempSet.circleRadius = 5.0
        tempSet.drawCirclesEnabled = true
        tempSet.mode = .cubicBezier
        tempSet.drawFilledEnabled = true
        if let gradient = [UIColor.blue, UIColor.white].setGradient() {
            let fill = LinearGradientFill(gradient: gradient, angle: 90.0)
            tempSet.fill = fill
        }

        
        // chart (X, Y)축 정보 표시 세팅
        self.chartView.xAxis.granularity = 1
        self.chartView.xAxis.labelCount = self.xAxisList.count
        self.chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: self.xAxisList)
        
        return tempSet
    }

}

extension DetailViewController {
    func bindCollectionView() {
        // weatherData, 컬렉션뷰에 바인딩
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, ForecastWeatherModel.WeatherItem>>(configureCell: { (_, collectionView, indexPath, element) in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCollectionViewCell", for: indexPath) as! WeatherCollectionViewCell
            cell.backgroundColor = .clear
            cell.updateCell(item: element)
            return cell
        })
        
        // Observable 데이터 소스를 컬렉션 뷰에 바인딩
        viewModel.weatherDataObservable
            .bind(to: weatherCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        // 선택된 셀에 대한 처리
        weatherCollectionView.rx.itemSelected
            .subscribe(onNext: { indexPath in
                print(indexPath)
            })
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
