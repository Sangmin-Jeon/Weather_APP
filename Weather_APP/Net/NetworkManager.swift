//
//  NetworkManager.swift
//  Weather_APP
//
//  Created by 전상민 on 2023/05/10.
//

import Foundation
import RxSwift
import Alamofire

let apiKey = ""

class NetworkManager {
    
    private let baseURL = "https://api.openweathermap.org"
    
    static let shared = NetworkManager()
    
    private func request<T: Codable>(path: String,
                                     method: HTTPMethod,
                                     parameters: Parameters? = nil) -> Observable<T> {
        
        guard let url = URL(string: baseURL.appending(path)) else {
            return Observable.error(NSError(domain: "Invalid URL", code: -1, userInfo: nil))
        }
        
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
                        observer.onError(error)
                    }
                }
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
}

extension NetworkManager {
    
    func get<T: Codable>(path: String, parameters: Parameters) -> Observable<T> {
        return request(path: path, method: .get, parameters: parameters)
    }
    
    func post<T: Codable>(path: String, parameters: Parameters) -> Observable<T> {
        return request(path: path, method: .post, parameters: parameters)
    }
    
}
