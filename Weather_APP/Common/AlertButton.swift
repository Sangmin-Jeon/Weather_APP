//
//  AlertButton.swift
//  Weather_APP
//
//  Created by 전상민 on 2023/05/13.
//

import Foundation
import UIKit
import RxSwift

extension UIViewController {
    public func showPopup(title: String, message: String, confirm: String) -> Observable<Bool> {
        return Observable.create { [weak self] observer -> Disposable in
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: confirm, style: .default) { _ in
                observer.onNext(true)
                observer.onCompleted()
            }
            alertController.addAction(confirmAction)
            
            self?.present(alertController, animated: true, completion: nil)
            
            return Disposables.create {
                alertController.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    public func showPopup(title: String, message: String, confirm: String, cancel: String) -> Observable<Bool> {
        return Observable.create { [weak self] observer -> Disposable in
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: confirm, style: .default) { _ in
                observer.onNext(true)
                observer.onCompleted()
            }
            alertController.addAction(confirmAction)
            
            let cancelAction = UIAlertAction(title: cancel, style: .destructive) { _ in
            }
            alertController.addAction(cancelAction)
            
            self?.present(alertController, animated: true, completion: nil)
            
            return Disposables.create {
                alertController.dismiss(animated: true, completion: nil)
            }
        }
    }
    
}
