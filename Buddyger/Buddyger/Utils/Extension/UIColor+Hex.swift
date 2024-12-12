//
//  UIColor+Hex.swift
//  Buddyger
//
//  Created by Filip Mileshkov on 2.12.24.
//

import UIKit


extension UIColor {
    
    /// Creates a UIColor from a hexadecimal color code.
    /// - Parameters:
    ///   - hex: The hexadecimal color code string. Supports formats with or without a leading `#` (e.g., `"#RRGGBB"` or `"RRGGBB"`) and optionally includes alpha (e.g., `"#RRGGBBAA"` or `"RRGGBBAA"`).
    ///   - defaultColor: The fallback color to use if the hex string is invalid. Defaults to `.clear` if not specified.
    convenience init(hex: String, defaultColor: UIColor = .clear) {
        var hexFormatted = hex.trimmingCharacters(in: .whitespacesAndNewlines)

        if hexFormatted.hasPrefix("#") {
            hexFormatted.removeFirst()
        }
        
        guard hexFormatted.count == 6 || hexFormatted.count == 8 else {
            self.init(cgColor: defaultColor.cgColor)
            return
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        let red, green, blue, alpha: CGFloat
        if hexFormatted.count == 6 {
            red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
            green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
            blue = CGFloat(rgbValue & 0x0000FF) / 255.0
            alpha = 1.0
        } else {
            red = CGFloat((rgbValue & 0xFF000000) >> 24) / 255.0
            green = CGFloat((rgbValue & 0x00FF0000) >> 16) / 255.0
            blue = CGFloat((rgbValue & 0x0000FF00) >> 8) / 255.0
            alpha = CGFloat(rgbValue & 0x000000FF) / 255.0
        }
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
