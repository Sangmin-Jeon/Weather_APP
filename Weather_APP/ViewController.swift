//
//  ViewController.swift
//  Weather_APP
//
//  Created by 전상민 on 2023/05/10.
//

import UIKit
import RxSwift
import RxRelay
import CoreLocation

enum LocationType {
    case lat
    case lon
}

class ViewController: UIViewController, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    let errorMessage = PublishSubject<String>()
    let disposeBag = DisposeBag()
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = false
        scrollView.bounces = false
        scrollView.isScrollEnabled = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    let contentView: UIView = {
        let contentView = UIView(frame: CGRect.zero)
        return contentView
    }()
    
    let curLocation = PublishSubject<[LocationType: Double]>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setAlert()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization() // 사용자에게 위치 접근 권한 요청
        locationManager.startUpdatingLocation() // 위치 업데이트 시작
    }
    
    // 테이블 뷰 높이 동적으로 설정
    func setTableViewDynamicHeight(tableView: UITableView) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let contentHeight = tableView.contentSize.height
            tableView.snp.updateConstraints { make in
                make.height.equalTo(contentHeight)
            }
            self.view.layoutIfNeeded()
        }
    }
    
    func setAlert() {
        // 에러 메세지 처리 팝업
        self.errorMessage
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

}

extension ViewController {
    // 위치 업데이트를 받으면 호출
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let manager = manager.location { // 가장 최근의 위치 정보 가져오기
            var locArr = [LocationType: Double]()
            locArr.updateValue(manager.coordinate.latitude, forKey: .lat)
            locArr.updateValue(manager.coordinate.longitude, forKey: .lon)
            self.curLocation.onNext(locArr)
        }
    }
    
    // 위치 접근이 실패하면 호출
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        #if !targetEnvironment(simulator)
        errorMessage.onNext(error.localizedDescription)
        #else
        print(error.localizedDescription)
        #endif
    }
    
}
