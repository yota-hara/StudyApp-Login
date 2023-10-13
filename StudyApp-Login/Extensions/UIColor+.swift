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

    public static let baseColor: UIColor = .red
}

