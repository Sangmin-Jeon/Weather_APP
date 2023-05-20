//
//  UIFont_Extension.swift
//  Weather_APP
//
//  Created by 전상민 on 2023/05/21.
//

import Foundation
import UIKit

enum FontType {
    case title
    case bold
    case regular
}

extension UIFont {
    func happiness(size: CGFloat, type: FontType) -> UIFont {
        switch type {
        case .title:
            return UIFont(name: "Happiness-Sans-Title", size: size)!
        case .bold:
            return UIFont(name: "Happiness-Sans-Bold", size: size)!
        case .regular:
            return UIFont(name: "Happiness-Sans-Regular", size: size)!
        }
    }
}
