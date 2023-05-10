//
//  MainViewController.swift
//  Weather_APP
//
//  Created by 전상민 on 2023/05/10.
//

import UIKit
import RxSwift
import RxCocoa

class MainViewController: ViewController {
    private let temperatureLabel = UILabel()
    private let pressureLabel = UILabel()
    private let humidityLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let weatherIconImageView = UIImageView()

    private let viewModel = MainViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupLayout()
        self.bindData()
        // 위도, 경도 임시
        viewModel.setWeatherData(latitude: 37.5665, longitude: 126.9780)
    }
    
    // UI 작성 함수
    private func setupLayout() {
        
    }
    
    // 데이터 바인딩
    private func bindData() {
        
    }
    
}
