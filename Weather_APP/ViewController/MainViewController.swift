//
//  MainViewController.swift
//  Weather_APP
//
//  Created by 전상민 on 2023/05/10.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Kingfisher

struct MainInfo {
    let imgUrl: URL
    let name: String
    let temp: String
    let pressure: String
    let humidity: String
    let desc: String
}

class MainViewController: ViewController {
    
    private let mainView = MainView(frame: CGRect.zero)
    private let viewModel = MainViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        #if targetEnvironment(simulator)
        // 시뮬레이터일 경우 서울로 고정
        viewModel.getWeatherData(latitude: 37.5665, longitude: 126.9780)
        viewModel.getHourlyWeatherData(latitude: 37.5665, longitude: 126.9780)
        #else
        self.getLocation()
        #endif
        
        view.addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
        
        self.bindData()
        self.bindTableView(weatherTableView: mainView.getWeatherTableView())
        
    }
    
    // MARK: 현재 날씨데이터 바인딩
    private func bindData() {
        // 현재 날씨 정보 표시
        viewModel.weatherData
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] data in
                guard let self = self else { return }
                if let first = data.weather.first,
                   let url = URL(string: "https://openweathermap.org/img/wn/\(first.icon)@2x.png") {
                    mainView.infoData = MainInfo(
                        imgUrl: url,
                        name: data.name,
                        temp: "온도 \(data.main.temp.kelvinToCelsius())°C",
                        pressure: "기압 \(data.main.pressure) hPa",
                        humidity: "습도 \(data.main.humidity)%",
                        desc:"현재 날씨 \(String(first.description))입니다."
                    )
                }
            })
            .disposed(by: disposeBag)
        
//        viewModel.weatherData
//            .compactMap { $0 }
//            .map { "습도 : \($0.main.humidity)%" }
//            .bind(to: humidityLabel.rx.text)
//            .disposed(by: disposeBag)
        
        // 에러 메세지 처리 팝업
        viewModel.errorMessage
            .flatMap { [weak self] errorMessage -> Observable<PopupType> in
                guard let self = self else { return .empty() }
                return self.showPopup(
                    title: errorMessage,
                    message: "",
                    confirm: "확인"
                )
            }
            .subscribe(onNext: { state in
                if state == .confirm {
                    // 확인
                }
                else {
                    // 취소
                }
            })
            .disposed(by: disposeBag)
    
    }
    
    // GPS정보 받아 오기
    func getLocation() {
        curLocation.subscribe(
            onNext: { [weak self] location in
                guard let self = self else { return }
                // 위도, 경도
                if let lat = location[.lat], let lon = location[.lon] {
                    self.viewModel.getWeatherData(latitude: lat, longitude: lon)
                    self.viewModel.getHourlyWeatherData(latitude: lat, longitude: lon)
                }
            },
            onError: { [weak self] error in
                guard let self = self else { return }
                self.errorMessage.onNext(error.localizedDescription)
            }
        )
        .disposed(by: disposeBag)
    }
    
}

// TODO: tableView에서 이벤트 받는 코드 MainView로 이동
// 데이터 받아서 넘기는 부분은 여기에서 수정
extension MainViewController {
    // MARK: 테이블 뷰 데이터 바인딩
    func bindTableView(weatherTableView: UITableView) {
        // weatherSections, 테이블뷰에 바인딩
        let dataSource = RxTableViewSectionedReloadDataSource<WeatherSectionModel>(configureCell: { (_, tableView, indexPath, element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherTableViewCell") as! WeatherTableViewCell
            cell.updateCell(key: element.date, value: element.weatherItems)
            cell.backgroundColor = .clear
            return cell
        }, titleForHeaderInSection: { dataSource, sectionIndex in
            dataSource[sectionIndex].header
        })
        
        // weatherList를 WeatherSectionModel 배열로 변환
        viewModel.weatherList
            .map { dict in
                let items = dict.map { WeatherItemModel(date: $0.key, weatherItems: $0.value) }
                let sorted = items.sorted(by: { $0.date < $1.date })
                return [WeatherSectionModel(header: "일기예보", items: sorted)]
            }
            .bind(to: viewModel.weatherSections)
            .disposed(by: disposeBag)
        
        // weatherSections, weatherTableView에 바인딩
        viewModel.weatherSections
            .bind(to: weatherTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        // 선택된 cell 처리
        weatherTableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                weatherTableView.deselectRow(at: indexPath, animated: false)
                
                viewModel.getSelctedItemIndex(index: indexPath.row) { [weak self] item in
                    let detailViewController = DetailViewController()
                    detailViewController.weatherData = item
                    self?.present(detailViewController, animated: true, completion: nil)
                    
                }
                
            })
            .disposed(by: disposeBag)
        
//        viewModel.weatherList
//            .map { $0.sorted(by: { $0.key < $1.key }) } // dict 정렬
//            .bind(to: weatherTableView.rx.items(
//                cellIdentifier: "WeatherTableViewCell",
//                cellType: WeatherTableViewCell.self)
//            ) { _, element, cell in
//                let (key, value) = element
//                cell.backgroundColor = .clear
//                cell.updateCell(key: key, value: value)
//
//            }
//            .disposed(by: disposeBag)
        
            
    }
}
