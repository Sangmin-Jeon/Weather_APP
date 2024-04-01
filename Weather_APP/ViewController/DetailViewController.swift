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
    
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont().happiness(size: 20, type: .title)
        titleLabel.textColor = .black
        return titleLabel
    }()
    
    let menuButton: UIButton = {
        let menuButton = UIButton(type: .system)
        menuButton.setImage(UIImage(systemName: "line.horizontal.3"), for: .normal)
        menuButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        menuButton.tintColor = .darkGray
        return menuButton
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
    
    let chartViewTitle: UILabel = {
        let chartViewTitle = UILabel()
        chartViewTitle.font = UIFont().happiness(size: 18, type: .bold)
        chartViewTitle.textColor = .black
        chartViewTitle.text = "기온 차트"
        return chartViewTitle
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
        weatherTableViewBackground.backgroundColor = .clear
        return weatherTableViewBackground
    }()
    
    let weatherCollectionViewTitle: UILabel = {
        let weatherCollectionViewTitle = UILabel()
        weatherCollectionViewTitle.font = UIFont().happiness(size: 18, type: .bold)
        weatherCollectionViewTitle.textColor = .black
        weatherCollectionViewTitle.text = "시간대별 날씨 정보"
        return weatherCollectionViewTitle
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
        
        weatherCollectionView.delegate = self
        weatherCollectionView.register(WeatherCollectionViewCell.self, forCellWithReuseIdentifier: "WeatherCollectionViewCell")
        
        viewModel.menuType = .temp // 타입에 따른 데이터 세팅
        setupLayout()
        bindData()
        bindCollectionView()
        
    }
    
    private func setupLayout() {
        view.addSubview(contentView)
        contentView.addSubview(titleBackgroundView)
        titleBackgroundView.addSubview(titleLabel)
        titleBackgroundView.addSubview(menuButton)
        contentView.addSubview(chartBackgroundView)
        chartBackgroundView.addSubview(chartViewTitle)
        chartBackgroundView.addSubview(chartView)
        contentView.addSubview(weatherCollectionBackgroundView)
        weatherCollectionBackgroundView.addSubview(weatherCollectionViewTitle)
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
        
        titleLabel.text = weatherData.first?.key.convertMonthNDay()
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(titleBackgroundView)
            make.leading.equalToSuperview().offset(10)
        }
        
        menuButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleBackgroundView)
            make.trailing.equalToSuperview().offset(-15)
        }
        
        chartBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(titleBackgroundView.snp.bottom).offset(20)
            make.height.equalTo(280)
            make.leading.equalToSuperview().offset(leftOffset)
            make.trailing.equalToSuperview().offset(rightOffset)
        }
        
        chartViewTitle.snp.makeConstraints { make in
            make.top.equalTo(chartBackgroundView).offset(10)
            make.leading.equalToSuperview().offset(leftOffset)
        }
        
        chartView.snp.makeConstraints { make in
            make.top.equalTo(chartViewTitle.snp.bottom).offset(10)
            make.height.equalTo(220)
            make.leading.equalToSuperview().offset(leftOffset)
            make.trailing.equalToSuperview().offset(rightOffset + 20)
        }
        
        weatherCollectionBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(chartBackgroundView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(150)
        }

        weatherCollectionViewTitle.snp.makeConstraints { make in
            make.top.equalTo(weatherCollectionBackgroundView).offset(10)
            make.leading.equalTo(weatherCollectionBackgroundView).offset(leftOffset)
        }

        weatherCollectionView.snp.updateConstraints { make in
            make.top.equalTo(weatherCollectionViewTitle.snp.bottom).offset(10)
            make.left.right.bottom.equalTo(weatherCollectionBackgroundView)
        }
        
    }
    
    private func bindData() {
        menuButton.rx.tap
            .subscribe(onNext: {
                let menu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                
                let action1 = UIAlertAction(title: "날씨 기온", style: .default) { [weak self] _ in
                    guard let self = self else { return }
                    if self.viewModel.menuType != .temp {
                        self.viewModel.menuType = .temp
                        self.chartViewTitle.text = String("\(String(describing: self.viewModel.menuType.rawValue)) 차트")
                    }
                }
                let action2 = UIAlertAction(title: "기압", style: .default) { [weak self] _ in
                    guard let self = self else { return }
                    if self.viewModel.menuType != .pressure {
                        self.viewModel.menuType = .pressure
                        self.chartViewTitle.text = String("\(String(describing: self.viewModel.menuType.rawValue)) 차트")
                    }
                }
                
                menu.addAction(action1)
                menu.addAction(action2)
                
                self.present(menu, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
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
        var highEntries = [ChartDataEntry]()
        switch viewModel.menuType {
        case .temp:
            highEntries = values.enumerated().map { (index, temp) -> ChartDataEntry in
                if let getTemp = Double(temp.temp ?? "") {
                    self.xAxisList.append(temp.dt.convertHour())
                    return ChartDataEntry(x: Double(index), y: getTemp)
                }
                return ChartDataEntry()
               
            }
        case .pressure:
            highEntries = values.enumerated().map { (index, temp) -> ChartDataEntry in
                let getPressure =  Double(temp.pressure ?? 0)
                self.xAxisList.append(temp.dt.convertHour())
                return ChartDataEntry(x: Double(index), y: getPressure)
                
            }
        }
        
        // Chart UI 정보 세팅
        let tempSet = LineChartDataSet(entries: highEntries, label: "\(viewModel.menuType.rawValue)정보")
        tempSet.setColor(UIColor(named: "SkyBlue")!.withAlphaComponent(1))
        tempSet.setCircleColor(.gray)
        tempSet.circleRadius = 5.0
        tempSet.drawCirclesEnabled = true
        tempSet.mode = .cubicBezier
        tempSet.drawFilledEnabled = true
        if let gradient = [UIColor(named: "SkyBlue")!.withAlphaComponent(1), UIColor.white].setGradient() {
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

// MARK: CollectionView Delegate
extension DetailViewController: UICollectionViewDelegateFlowLayout {
    // RxDataSources에서 Cell의 크기를 구할 수 없어서 Delegate패턴 사용
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
}


extension Reactive where Base: LineChartView {
    var data: Binder<LineChartData> {
        return Binder(self.base) { view, data in
            view.data = data
        }
    }
}
