//
//  UIColorArr_Extension.swift
//  Weather_APP
//
//  Created by 전상민 on 2023/05/21.
//

import Foundation
import UIKit

extension [UIColor] {
    // 그라데이션 색 설정
    func setGradient() -> CGGradient? {
        if let color1 = self.first, let color2 = self.last {
            let gradientColors = [color1.cgColor, color2.cgColor] as CFArray
            let colorLocations: [CGFloat] = [1.0, 0.0]
            let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations)!
            return gradient
        }
        return nil
    }
}
