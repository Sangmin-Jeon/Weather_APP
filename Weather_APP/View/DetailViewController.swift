//
//  DetailViewController.swift
//  Weather_APP
//
//  Created by 전상민 on 2023/05/19.
//

import UIKit
import RxSwift
import SnapKit

class DetailViewController: UIViewController {
    let viewModel = DetailViewModel()

    var weatherData = [String : [ForecastWeatherModel.WeatherItem]]()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
    
        print(weatherData)
        
    }
    

}
