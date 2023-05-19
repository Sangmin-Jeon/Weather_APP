//
//  String_Extension.swift
//  Weather_APP
//
//  Created by 전상민 on 2023/05/15.
//

import Foundation

extension String {
    func toDateString() -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "yyyy-MM-dd"
        
        if let date = dateFormatterGet.date(from: self) {
            return dateFormatterPrint.string(from: date)
        }
        else {
            return ""
        }
    }
    
    func convertMonthNDay() -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MM월 dd일"
        
        if let date = dateFormatterGet.date(from: self) {
            return dateFormatterPrint.string(from: date)
        }
        else {
            return ""
        }
    }
}
