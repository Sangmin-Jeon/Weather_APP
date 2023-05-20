//
//  CustomMarkerView.swift
//  Weather_APP
//
//  Created by 전상민 on 2023/05/20.
//

import Foundation
import UIKit
import Charts

class CustomMarkerView: MarkerView {
    var text = ""

    override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        super.refreshContent(entry: entry, highlight: highlight)

        // 마커에 표시할 정보
        text = "\(entry.y)°C"
    }
    
    override func draw(context: CGContext, point: CGPoint) {
        super.draw(context: context, point: point)
        
        let attributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12),
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        let size = text.size(withAttributes: attributes)
        let rect = CGRect(origin: point, size: size)
        let radius: CGFloat = 5.0
        
        // 배경색
        context.setFillColor(UIColor.black.withAlphaComponent(0.8).cgColor)
        
        let path = UIBezierPath(roundedRect: rect.insetBy(dx: -5, dy: -5), cornerRadius: radius).cgPath
        context.addPath(path)
        context.fillPath()
        
        
        text.draw(in: rect, withAttributes: attributes)
    }
}
