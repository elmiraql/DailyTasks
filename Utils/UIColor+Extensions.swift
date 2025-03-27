//
//  UIColor+Extensions.swift
//  DailyTasks
//
//  Created by Elmira Qurbanova on 24.03.25.
//

import UIKit

extension UIColor {
    
    static let lightGrayColor = UIColor(hex: "#484444") ?? .lightGray
    static let blackColor = UIColor(hex: "#171416") ?? .black
    static let darkGrayColor = UIColor(hex: "#242121") ?? .darkGray
    static let greenColor = UIColor(hex: "#4A702D") ?? .darkGray
    static let brightGreenColor = UIColor(hex: "#8DDF3C") ?? .darkGray
//background: #272729;

    
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        let red = CGFloat((rgb >> 16) & 0xFF) / 255.0
        let green = CGFloat((rgb >> 8) & 0xFF) / 255.0
        let blue = CGFloat(rgb & 0xFF) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
