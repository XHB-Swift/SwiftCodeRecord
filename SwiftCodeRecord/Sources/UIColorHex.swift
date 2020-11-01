//
//  UIColorHex.swift
//  SwiftCodeRecord
//
//  Created by xiehongbiao on 2020/10/26.
//

import UIKit

extension UIColor {
    
    public convenience init(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat = 1.0) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: (alpha > 1 || alpha < 0) ? 1.0 : alpha)
    }
    public convenience init(rgbhHex: Int, alpha: CGFloat = 1.0) {
        
        let r = CGFloat((rgbhHex & 0xFF0000) >> 16)
        let g = CGFloat((rgbhHex & 0xFF00) >> 8)
        let b = CGFloat(rgbhHex & 0xFF)
        self.init(r: r, g: g, b: b, alpha: alpha)
    }
    public convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        var rgb: UInt64 = 0
        let length = hexSanitized.count
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 1.0
        if length == 6 {
            red = CGFloat((rgb & 0xFF0000) >> 16)
            green = CGFloat((rgb & 0x00FF00) >> 8)
            blue = CGFloat(rgb & 0x0000FF)
        } else if length == 8 {
            alpha = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            red = CGFloat((rgb & 0x00FF0000) >> 16)
            green = CGFloat((rgb & 0x0000FF00) >> 8)
            blue = CGFloat(rgb & 0x000000FF)
        } else {
            return nil
        }
        self.init(r: red, g: green, b: blue, alpha: alpha)
    }
    
}
