//
//  Double_Extension.swift
//  Weather_APP
//
//  Created by 전상민 on 2023/05/14.
//

import Foundation

extension Double {
    // 절대온도 -> 섭씨온도 변환
    func kelvinToCelsius() -> String {
        let celsius = self - 273.15
        return String(format: "%.1f", celsius)
    }
}
