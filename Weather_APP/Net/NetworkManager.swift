//
//  NetworkManager.swift
//  Weather_APP
//
//  Created by 전상민 on 2023/05/10.
//

import Foundation
import RxSwift
import Alamofire

struct MyLocation {
    let latitude: Double
    let longitude: Double
}

class NetworkManager {
    static let shared = NetworkManager()
    
    private let baseURL = String("https://api.openweathermap.org")
    
    func get<T: Codable>(path: String, myLocation: MyLocation) -> Observable<T> {
        return request(path: path, method: .get, myLocation: myLocation)
    }
    
    func post<T: Codable>(path: String, myLocation: MyLocation) -> Observable<T> {
        return request(path: path, method: .post, myLocation: myLocation)
    }
    
}

extension NetworkManager {
    private func request<T: Codable>(path: String,
                                     method: HTTPMethod,
                                     myLocation: MyLocation) -> Observable<T> {
        guard let url = URL(string: baseURL.appending(path)) else {
            return Observable.error(NSError(domain: "Invalid URL", code: -1, userInfo: nil))
        }
        
        let parameters: Parameters = [
            "lat": myLocation.latitude,
            "lon": myLocation.longitude,
            "appid": APIManager.shared.apiKey,
            "lang": "kr"
        ]
        
        return Observable.create { observer -> Disposable in
            let request = AF.request(url, method: method, parameters: parameters)
                .validate(statusCode: 200 ..< 401)
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case .success(let data):
                        dump(data)
                        observer.onNext(data)
                        observer.onCompleted()
                    case .failure(let error):
                        dump(error)
                        observer.onError(error)
                    }
                }
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
}
