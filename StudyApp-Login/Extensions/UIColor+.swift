//
//  UIColor+.swift
//  StudyApp-Login
//
//  Created by yotahara on 2023/10/13.
//

import UIKit

// UIColorに名前空間rtを適用
extension UIColor: RingTechCompatible {
    typealias rt = RingTech<UIColor>
}

// UIColorの拡張を名前空間rtに実装する
extension RingTech where Base == UIColor {

    public static let blue = initialize(withHex: "#0000BA")!
    public static let navy = initialize(withHex: "#003366")!
    public static let lightBlue = initialize(withHex: "#2DA0FA")!
    public static let red = initialize(withHex: "#ff2b2b")!
    public static let yellow = initialize(withHex: "#FFD43B")!
    
    public static let white = UIColor.white
    public static let black = UIColor.black

    public static let gray10 = initialize(withHex: "#E1E1E1")!
    public static let gray20 = initialize(withHex: "#CFCFCF")!
    public static let gray30 = initialize(withHex: "#B1B1B1")!
    public static let gray40 = initialize(withHex: "#9E9E9E")!
    public static let gray50 = initialize(withHex: "#7E7E7E")!
    public static let gray60 = initialize(withHex: "#626262")!
    public static let gray70 = initialize(withHex: "#515151")!
    public static let gray80 = initialize(withHex: "#3B3B3B")!
    public static let gray90 = initialize(withHex: "#222222")!

    // Hexによるイニシャライザ関数
    private static func initialize(withHex hex: String) -> UIColor? {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0
        
        let length = hexSanitized.count
        
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }
        
        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0
        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0
        } else {
            return nil
        }
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}


